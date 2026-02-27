import 'package:flutter/material.dart';
import 'package:zavisoft/core/components/customSize.dart';
import 'package:zavisoft/widget/customText.dart';
import '../models/product_model.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;

  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
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

          /// Product info
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start,
                ),
                heightBox5,
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
                    const SizedBox(width: 2),
                    CustomText(
                      text: product.rating.rate.toStringAsFixed(1),
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                    widthBox5,
                    CustomText(
                      text: '(${product.rating.count})',
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ],
                ),
                heightBox5,
                CustomText(
                  text: '\$${product.price.toStringAsFixed(2)}',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE53935),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
