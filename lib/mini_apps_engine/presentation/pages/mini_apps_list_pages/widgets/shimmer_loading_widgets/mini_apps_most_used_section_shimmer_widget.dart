import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

//!
class MiniAppsMostUsedSectionShimmerWidget extends StatelessWidget {
  const MiniAppsMostUsedSectionShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = _ShimmerPalette.of(context);

    // Mirrors the real "most used" row in MiniAppsHomeScreen: h64 tall, text-scale aware.
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);
    final double rowHeight = context.h(64) * (1.0 + (textScale - 1.0) * 0.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title shimmer
        Shimmer.fromColors(
          baseColor: palette.base,
          highlightColor: palette.highlight,
          child: Container(
            width: context.w(195),
            height: context.h(35),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: palette.border, width: 1),
              boxShadow: [
                BoxShadow(color: palette.shadow, blurRadius: palette.isDark ? 10 : 8, offset: const Offset(0, 6)),
              ],
            ),
          ),
        ),

        SizedBox(height: context.screenHeight * 0.01),

        // Horizontal list shimmer wrapper
        SizedBox(
          height: rowHeight,
          width: context.screenWidth,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => SizedBox(width: context.screenWidth * 0.02),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) => const _MostUsedShimmerCard(),
          ),
        ),
      ],
    );
  }
}

/// One placeholder card, mirroring the real horizontal "most used" card:
/// a w177 box with a 48x48 leading icon and up to two title lines beside it.
class _MostUsedShimmerCard extends StatelessWidget {
  const _MostUsedShimmerCard();

  @override
  Widget build(BuildContext context) {
    final palette = _ShimmerPalette.of(context);

    final textScale = MediaQuery.of(context).textScaler.scale(1.0);
    final double cardWidth = context.w(177) * (1.0 + (textScale - 1.0) * 0.2);

    return Shimmer.fromColors(
      baseColor: palette.base,
      highlightColor: palette.highlight,
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: palette.border, width: 1),
          boxShadow: [
            BoxShadow(color: palette.shadow, blurRadius: palette.isDark ? 10 : 8, offset: const Offset(0, 6)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              // Icon placeholder: square, sized from the available height so it
              // can never overflow the row, whatever the text scale is.
              AspectRatio(
                aspectRatio: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: palette.iconPlaceholder,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: palette.iconBorder, width: 1),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Title placeholders (the real card renders up to two lines).
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        height: context.h(12),
                        decoration: BoxDecoration(
                          color: palette.textPlaceholder,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    SizedBox(height: context.h(6)),
                    Flexible(
                      child: FractionallySizedBox(
                        alignment: AlignmentDirectional.centerStart,
                        widthFactor: 0.6,
                        child: Container(
                          height: context.h(12),
                          decoration: BoxDecoration(
                            color: palette.textPlaceholder,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Premium shimmer palette (no pure black), shared by the section and its cards.
class _ShimmerPalette {
  const _ShimmerPalette({
    required this.isDark,
    required this.base,
    required this.highlight,
    required this.surface,
    required this.iconPlaceholder,
    required this.textPlaceholder,
    required this.border,
    required this.iconBorder,
    required this.shadow,
  });

  factory _ShimmerPalette.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _ShimmerPalette(
      isDark: isDark,
      base: isDark ? const Color(0xFF2A2F3A) : const Color(0xFFE7E9EF),
      highlight: isDark ? const Color(0xFF3A4150) : const Color(0xFFF5F6FA),
      surface: isDark ? const Color(0xFF141821) : Colors.white,
      iconPlaceholder: isDark ? const Color(0xFF1D2430) : Colors.white.withValues(alpha: 0.55),
      textPlaceholder: isDark ? const Color(0xFF1D2430) : Colors.white,
      border: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
      iconBorder: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.03),
      shadow: isDark ? Colors.black.withValues(alpha: 0.35) : Colors.black.withValues(alpha: 0.06),
    );
  }

  final bool isDark;
  final Color base;
  final Color highlight;
  final Color surface;
  final Color iconPlaceholder;
  final Color textPlaceholder;
  final Color border;
  final Color iconBorder;
  final Color shadow;
}
