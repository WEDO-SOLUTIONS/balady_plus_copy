import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MiniAppsSearchTextFieldShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  final double horizontalPadding;

  const MiniAppsSearchTextFieldShimmer({super.key, this.height, this.width, this.horizontalPadding = 8});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Premium shimmer palette
    final baseColor = isDark ? const Color(0xFF2A2F3A) : const Color(0xFFE7E9EF);
    final highlightColor = isDark ? const Color(0xFF3A4150) : const Color(0xFFF5F6FA);

    // Field surface + placeholders
    final fieldBg = isDark ? const Color(0xFF141821) : Colors.white;
    final placeholder = isDark ? const Color(0xFF1D2430) : Colors.white;

    // Subtle border for premium feel
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06);

    // Optional shadow (very subtle)
    final shadowColor = isDark ? Colors.black.withValues(alpha: 0.35) : Colors.black.withValues(alpha: 0.05);

    return SizedBox(
      width: width ?? context.screenWidth,
      height: height ?? context.h(48),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            height: height ?? context.h(48),
            decoration: BoxDecoration(
              color: fieldBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 1),
              boxShadow: [BoxShadow(color: shadowColor, blurRadius: isDark ? 10 : 8, offset: const Offset(0, 6))],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Left side "text" placeholder (like hint)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 12,
                        width: 160,
                        decoration: BoxDecoration(color: placeholder, borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),

                  // Right side "search2" placeholder (matches suffixString)
                  Container(
                    height: 12,
                    width: 70,
                    decoration: BoxDecoration(color: placeholder, borderRadius: BorderRadius.circular(8)),
                  ),

                  const SizedBox(width: 16),

                  // Right side icon placeholder (matches suffixIcon)
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: placeholder,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
                        width: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
