
import 'package:flutter/material.dart';


class ProductCardShimmer extends StatefulWidget {
  const ProductCardShimmer({super.key});

  @override
  State<ProductCardShimmer> createState() => _ProductCardShimmerState();
}

class _ProductCardShimmerState extends State<ProductCardShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Card(
          elevation: 2,
          color: Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image placeholder ──────────────────────────────────
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: _ShimmerBox(
                    shimmerValue: _animation.value,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),

              // ── Info placeholder ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title line 1
                    _ShimmerBox(
                      shimmerValue: _animation.value,
                      height: 11,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 5),
                    // Title line 2 (shorter)
                    _ShimmerBox(
                      shimmerValue: _animation.value,
                      height: 11,
                      width: 120,
                    ),
                    const SizedBox(height: 8),
                    // Rating row
                    Row(
                      children: [
                        _ShimmerBox(
                          shimmerValue: _animation.value,
                          height: 11,
                          width: 14,
                        ),
                        const SizedBox(width: 4),
                        _ShimmerBox(
                          shimmerValue: _animation.value,
                          height: 11,
                          width: 28,
                        ),
                        const SizedBox(width: 6),
                        _ShimmerBox(
                          shimmerValue: _animation.value,
                          height: 11,
                          width: 28,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Price
                    _ShimmerBox(
                      shimmerValue: _animation.value,
                      height: 14,
                      width: 60,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// _ShimmerBox — reusable shimmer block with sweep gradient
// ════════════════════════════════════════════════════════════════════

class _ShimmerBox extends StatelessWidget {
  final double shimmerValue;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const _ShimmerBox({
    required this.shimmerValue,
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        gradient: LinearGradient(
          begin: Alignment(shimmerValue - 1, 0),
          end: Alignment(shimmerValue, 0),
          colors: const [
            Color(0xFFEEEEEE),
            Color(0xFFF5F5F5),
            Color(0xFFE0E0E0),
            Color(0xFFF5F5F5),
            Color(0xFFEEEEEE),
          ],
          stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// ProductGridShimmer — 6টা shimmer card এর ready-made grid
// Usage: loading && products.isEmpty হলে এটা দেখাও
// ════════════════════════════════════════════════════════════════════

class ProductGridShimmer extends StatelessWidget {
  /// কতটা shimmer card দেখাবে (default 6)
  final int itemCount;

  const ProductGridShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // physics: NeverScrollableScrollPhysics() দেওয়া হয়নি যাতে
      // NestedScrollView এর inner coordinator কাজ করে
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.65, // ProductCardWidget এর মতোই
            ),
            delegate: SliverChildBuilderDelegate(
                  (_, __) => const ProductCardShimmer(),
              childCount: itemCount,
            ),
          ),
        ),
      ],
    );
  }
}