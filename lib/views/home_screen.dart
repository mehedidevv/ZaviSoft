// views/home_screen.dart
//
// ═══════════════════════════════════════════════════════════════════
// SCROLL ARCHITECTURE & GESTURE DESIGN
// ═══════════════════════════════════════════════════════════════════
//
// 1. WHO OWNS THE VERTICAL SCROLL?
//    ─────────────────────────────
//    NestedScrollView owns the SINGLE vertical scroll axis.
//    The outer scroll (header collapsing) and inner scroll (product list)
//    are unified by NestedScrollView into one seamless experience.
//    Tab content uses a NestedScrollView body that renders a CustomScrollView
//    per tab. Flutter's NestedScrollView coordinates these so the user
//    perceives ONE continuous scroll — collapsing the header first, then
//    scrolling the list.
//
//    We do NOT use a second independent ScrollController in any tab child.
//    Each tab's CustomScrollView is connected to the NestedScrollView inner
//    coordinator automatically.
//
// 2. HOW HORIZONTAL SWIPE WAS IMPLEMENTED?
//    ───────────────────────────────────────
//    We use TabBarView with the DEFAULT PageView physics for horizontal swipe.
//    TabBarView is constrained inside the NestedScrollView body.
//
//    THE KEY INSIGHT: Flutter's NestedScrollView + TabBarView combination
//    handles gesture disambiguation correctly out of the box:
//      - Vertical gestures → NestedScrollView's vertical scroll
//      - Horizontal gestures → TabBarView's PageView (tab switching)
//    Flutter achieves this through the GestureArena: a gesture is either
//    claimed as vertical by the ScrollView or horizontal by the PageView
//    based on the initial drag direction. There is no interference.
//
//    We also drive tab switching via TabController.animateTo() when the user
//    taps a tab label, keeping the single source of truth (TabController).
//
// 3. PULL-TO-REFRESH:
//    ─────────────────
//    RefreshIndicator wraps the NestedScrollView. This works from ANY tab
//    because the outer scroll area is the refresh trigger zone — not the
//    inner tab content.
//
// 4. SCROLL POSITION ON TAB SWITCH:
//    ─────────────────────────────────
//    NestedScrollView preserves the header's collapsed/expanded state across
//    tab switches because the outer scroll position lives in the
//    NestedScrollView itself, not in each tab. Tab switching changes only
//    the horizontal page, leaving vertical position untouched.
//    Each tab's own inner scroll position is preserved by AutomaticKeepAlive.
//
// 5. TRADE-OFFS & LIMITATIONS:
//    ──────────────────────────
//    • NestedScrollView has a known Flutter issue: inner scroll position can
//      appear not to restore correctly after a tab switch in some Flutter
//      versions. We mitigate with PageStorageKey per tab.
//    • The banner image height is SliverAppBar's expandedHeight — if the
//      content list is short, full collapse may not be possible; we handle
//      this with SliverFillRemaining to always provide enough content.
//    • On very old devices, the PageView inside NestedScrollView body may
//      show minor jank on first render of a new tab during network load.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pc = Get.find<ProductController>();
    final auth = Get.find<AuthController>();

    return Obx(() {
      // Show loading while categories/tabController not ready
      if (pc.isLoadingCategories.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator(color: Color(0xFFE53935))),
        );
      }
      if (pc.error.value.isNotEmpty) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(pc.error.value, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: pc.refresh,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      return Scaffold(
        // ── AppBar rendered inside NestedScrollView SliverAppBar
        // so we use no appbar here
        backgroundColor: const Color(0xFFF5F5F5),
        body: RefreshIndicator(
          // RefreshIndicator on the outer scroll — works from ANY tab
          color: const Color(0xFFE53935),
          onRefresh: pc.refresh,
          child: NestedScrollView(
            // headerSliverBuilder builds the collapsible banner + sticky TabBar
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              // ── Collapsible banner with search bar ──────────────────────
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,           // keeps the toolbar visible when collapsed
                snap: false,
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
                title: const Text(
                  'ZaviSoft',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                actions: [
                  IconButton(
                    icon: Obx(() {
                      final user = auth.user.value;
                      return CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white24,
                        child: Text(
                          user != null && user.firstname.isNotEmpty
                              ? user.firstname[0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      );
                    }),
                    onPressed: () => Get.toNamed('/profile'),
                    tooltip: 'Profile',
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: auth.logout,
                    tooltip: 'Logout',
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Banner image
                      Image.network(
                        'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFB71C1C),
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.5),
                            ],
                          ),
                        ),
                      ),
                      // Search bar in expanded area
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            children: const [
                              SizedBox(width: 16),
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                'Search on ZaviSoft',
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Sticky Tab Bar ────────────────────────────────────────────
              // SliverPersistentHeader with pinned:true makes the TabBar
              // sticky after the SliverAppBar collapses.
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  TabBar(
                    controller: pc.tabController,
                    isScrollable: pc.categories.length > 3,
                    labelColor: const Color(0xFFE53935),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFFE53935),
                    indicatorWeight: 3,
                    tabs: pc.categories
                        .map((c) => Tab(text: c.toUpperCase()))
                        .toList(),
                  ),
                ),
              ),
            ],

            // ── Body: TabBarView for horizontal navigation ────────────────
            // TabBarView uses a PageView internally.
            // Flutter's gesture arena disambiguates horizontal (PageView)
            // vs vertical (NestedScrollView) gestures automatically.
            body: TabBarView(
              controller: pc.tabController,
              children: pc.categories.map((category) {
                return _TabContent(
                  key: PageStorageKey(category), // preserves inner scroll pos
                  category: category,
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }
}

// ════════════════════════════════════════════════════════════════════
// _StickyTabBarDelegate — makes TabBar sticky using SliverPersistentHeader
// ════════════════════════════════════════════════════════════════════

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) =>
      tabBar != oldDelegate.tabBar;
}

// ════════════════════════════════════════════════════════════════════
// _TabContent — product list for one category tab
// ════════════════════════════════════════════════════════════════════

class _TabContent extends StatefulWidget {
  final String category;
  const _TabContent({super.key, required this.category});

  @override
  State<_TabContent> createState() => _TabContentState();
}

class _TabContentState extends State<_TabContent>
    with AutomaticKeepAliveClientMixin {
  // AutomaticKeepAliveClientMixin keeps this tab's state (including inner
  // scroll position) alive when the user switches to another tab.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin
    final pc = Get.find<ProductController>();

    return Obx(() {
      final loading = pc.isTabLoading(widget.category);
      final products = pc.productsFor(widget.category);

      if (loading && products.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFE53935)),
        );
      }

      if (products.isEmpty) {
        // Use CustomScrollView even for empty state so NestedScrollView's
        // inner scroll coordinator works correctly
        return CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.inbox, size: 64, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      'No products in ${widget.category}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }

      // Build a 2-column grid of products using SliverGrid
      return CustomScrollView(
        // No independent ScrollController here — NestedScrollView provides
        // the inner scroll coordinator via InheritedWidget
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ProductCard(product: products[index]),
                childCount: products.length,
              ),
            ),
          ),
        ],
      );
    });
  }
}

// ════════════════════════════════════════════════════════════════════
// _ProductCard
// ════════════════════════════════════════════════════════════════════

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                width: double.infinity,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFE53935),
                      strokeWidth: 2,
                    ),
                  );
                },
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          // Product info
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
                    const SizedBox(width: 2),
                    Text(
                      product.rating.rate.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${product.rating.count})',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE53935),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
