import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class MiniAppsShimmerLoadingWidget extends StatelessWidget {
  final int itemCount;

  const MiniAppsShimmerLoadingWidget({super.key, this.itemCount = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      child: SingleChildScrollView(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) => const _ShimmerCard(),
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Premium-ish shimmer palette (not pure black)
    final baseColor = isDark ? const Color(0xFF2A2F3A) : const Color(0xFFE7E9EF);
    final highlightColor = isDark ? const Color(0xFF3A4150) : const Color(0xFFF5F6FA);

    // Card + placeholders (use soft surfaces)
    final cardBg = isDark ? const Color(0xFF141821) : Colors.white;
    final cardBorder = isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04);

    final placeholder = isDark ? const Color(0xFF1D2430) : Colors.white;
    final placeholderSoft = isDark ? const Color(0xFF202838) : Colors.white;

    final shadowColor = isDark ? Colors.black.withOpacity(0.35) : Colors.black.withOpacity(0.06);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: context.w(104),
        height: context.h(104),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cardBorder, width: 1),
          boxShadow: [BoxShadow(color: shadowColor, blurRadius: isDark ? 10 : 8, offset: const Offset(0, 6))],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(10), vertical: context.h(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon placeholder (slight border for premium look)
              Container(
                width: context.w(48),
                height: context.h(48),
                decoration: BoxDecoration(
                  color: placeholder,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cardBorder, width: 1),
                ),
              ),
              SizedBox(height: context.h(10)),

              // Title placeholder
              Container(
                width: context.w(60),
                height: context.h(14),
                decoration: BoxDecoration(color: placeholderSoft, borderRadius: BorderRadius.circular(6)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
