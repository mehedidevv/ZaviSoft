import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/product_controller.dart';
import '../widget/productCardWidget.dart';
import '../widget/productGridShimmer.dart';

class TabContent extends StatefulWidget {
  final String category;
  const TabContent({super.key, required this.category});

  @override
  State<TabContent> createState() => _TabContentState();
}

class _TabContentState extends State<TabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final pc = Get.find<ProductController>();

    return Obx(() {
      final loading = pc.isTabLoading(widget.category);
      final products = pc.productsFor(widget.category);

      if (loading && products.isEmpty) {
        return  Center(
          child: ProductGridShimmer(itemCount: 4,),
        );
      }

      if (products.isEmpty) {
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

      /// Build a 2-column grid of products using SliverGrid
      return CustomScrollView(
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
                    (context, index) => ProductCardWidget(product: products[index]),
                childCount: products.length,
              ),
            ),
          ),
        ],
      );
    });
  }
}
