
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
import 'package:zavisoft/views/tabContent.dart';
import 'package:zavisoft/widget/customText.dart';
import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final authController = Get.find<AuthController>();

    return Obx(() {
      if (productController.isLoadingCategories.value) {
        return  Scaffold(
          body: Center(child: CircularProgressIndicator(color: Color(0xFFE53935))),
        );
      }
      if (productController.error.value.isNotEmpty) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(productController.error.value, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: productController.refresh,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: RefreshIndicator(
          color: const Color(0xFFE53935),
          onRefresh: productController.refresh,
          notificationPredicate: (notification) => notification.depth == 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                snap: false,
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
                title: CustomText(
                  text: 'ZaviSoft',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                ),
                actions: [
                  IconButton(
                    icon: Obx(() {
                      final user = authController.user.value;
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
                    onPressed: authController.logout,
                    tooltip: 'Logout',
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      /// Banner image
                      Image.network(
                        'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&auto=format&fit=crop',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFB71C1C),
                        ),
                      ),
                      /// Gradient overlay
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

                    ],
                  ),
                ),
              ),

              /// -------------------- Sticky Tab Bar -----------------
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  TabBar(
                    controller: productController.tabController,
                    isScrollable: productController.categories.length > 3,
                    labelColor: const Color(0xFFE53935),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFFE53935),
                    indicatorWeight: 3,
                    tabs: productController.categories
                        .map((c) => Tab(text: c.toUpperCase()))
                        .toList(),
                  ),
                ),
              ),
            ],

            /// ── Body: TabBarView for horizontal navigation ────────────────
            body: TabBarView(
              controller: productController.tabController,
              children: productController.categories.map((category) {
                return TabContent(
                  key: PageStorageKey(category),
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



