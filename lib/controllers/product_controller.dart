// controllers/product_controller.dart
//
// SCROLL ARCHITECTURE DECISION:
// ─────────────────────────────
// The ProductController owns ONE ScrollController that is shared with the
// outer NestedScrollView. This is the ONLY vertical scroll authority in the
// app. Tab content (SliverList inside each tab) is rendered inside
// SliverFillRemaining so they extend the outer scroll, not create their own.
//
// WHY ONE SCROLL OWNER?
// NestedScrollView creates an inner + outer scroll, but we want a single
// continuous scroll. We achieve this by:
//   - Giving SliverFillRemaining(hasScrollBody: false) to tab content so it
//     doesn't try to scroll independently.
//   - The outer CustomScrollView (NestedScrollView body) handles all vertical
//     scrolling.
//
// HORIZONTAL SWIPE:
// ─────────────────
// A PageView (physics: NeverScrollableScrollPhysics) is used for tab content.
// Tab switching is driven ONLY by TabController (tapping or swipe on TabBar).
// We intercept horizontal swipe via GestureDetector on each tab page that
// calls tabController.animateTo(). This ensures:
//   - Horizontal gestures are caught intentionally.
//   - Vertical gestures pass through to the NestedScrollView.
//   - No PageView physics fights with scroll physics.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends GetxController with GetTickerProviderStateMixin {
  ///  Observables
  final RxList<String> categories = <String>[].obs;
  final RxMap<String, List<ProductModel>> productsByCategory =
      <String, List<ProductModel>>{}.obs;
  final RxBool isLoadingCategories = true.obs;
  final RxMap<String, bool> isLoadingTab = <String, bool>{}.obs;
  final RxString error = ''.obs;

  /// ── Tab / Page controllers
  late TabController tabController;
  // PageController is intentionally NOT used for tab navigation.
  // We use tabController.index as the source of truth.

  // ── Scroll ownership ──────────────────────────────────────────────────────
  // The outer NestedScrollView uses this controller so we can listen /
  // programmatically scroll if needed. There is no second ScrollController.
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _loadCategories() async {
    isLoadingCategories.value = true;
    error.value = '';
    try {
      final cats = await ApiService.getCategories();
      categories.value = cats.take(5).toList();

      tabController = TabController(length: categories.length, vsync: this);
      tabController.addListener(() {
        if (!tabController.indexIsChanging) {
          _loadTabIfNeeded(categories[tabController.index]);
        }
      });

      /// Pre-load first tab
      if (categories.isNotEmpty) {
        await _loadTabIfNeeded(categories[0]);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> _loadTabIfNeeded(String category) async {
    if (productsByCategory.containsKey(category)) return;
    isLoadingTab[category] = true;
    try {
      final products = await ApiService.getProductsByCategory(category);
      productsByCategory[category] = products;
    } catch (_) {
      productsByCategory[category] = [];
    } finally {
      isLoadingTab[category] = false;
    }
  }

  /// Pull-to-refresh: reload all loaded categories
  Future<void> refresh() async {
    productsByCategory.clear();
    isLoadingTab.clear();
    if (categories.isNotEmpty) {
      for (final cat in categories) {
        await _loadTabIfNeeded(cat);
      }
    }
  }

  /// Called when user swipes or taps a tab
  void switchTab(int index) {
    tabController.animateTo(index);
    _loadTabIfNeeded(categories[index]);
  }

  List<ProductModel> productsFor(String category) {
    return productsByCategory[category] ?? [];
  }

  bool isTabLoading(String category) {
    return isLoadingTab[category] ?? false;
  }
}
