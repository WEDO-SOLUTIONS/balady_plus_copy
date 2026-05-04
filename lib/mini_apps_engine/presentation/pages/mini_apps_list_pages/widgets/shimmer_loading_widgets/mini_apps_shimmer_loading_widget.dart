// assumes you already have these extensions in your project:
// context.screenWidth, context.w(...), context.h(...)

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
    final baseColor = isDark
        ? const Color(0xFF2A2F3A)
        : const Color(0xFFE7E9EF);
    final highlightColor = isDark
        ? const Color(0xFF3A4150)
        : const Color(0xFFF5F6FA);

    // Card + placeholders (use soft surfaces)
    final cardBg = isDark ? const Color(0xFF141821) : Colors.white;
    final cardBorder = isDark
        ? const Color(0xFF232A36)
        : const Color(0xFFE9ECF3);

    final placeholder = isDark ? const Color(0xFF1D2430) : Colors.white;
    final placeholderSoft = isDark ? const Color(0xFF202838) : Colors.white;

    final shadowColor = isDark
        ? Colors.black.withOpacity(0.35)
        : Colors.black.withOpacity(0.06);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: context.w(87.12268829345703),
        height: context.h(87.12268829345703),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cardBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: isDark ? 10 : 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon placeholder (slight border for premium look)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: placeholder,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.black.withOpacity(0.04),
                    width: 1,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Title placeholder
              Container(
                width: 82,
                height: 12,
                decoration: BoxDecoration(
                  color: placeholderSoft,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle placeholder
              Container(
                width: 58,
                height: 10,
                decoration: BoxDecoration(
                  color: placeholderSoft,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
