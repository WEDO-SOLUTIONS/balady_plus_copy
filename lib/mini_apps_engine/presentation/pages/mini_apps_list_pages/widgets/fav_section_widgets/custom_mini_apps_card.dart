import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:flutter/material.dart';

//!
class CustomMiniAppsCard extends StatelessWidget {
  final double? width;
  final double? height;

  final double? iconWidth;
  final double? iconHeight;

  final double? titlesWidth;
  final double? titlesHeight;

  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  final String? text;
  final String? miniAppIcon;
  final bool withCardEffect;
  final List<BoxShadow>? boxShadow;

  final int? maxLines;

  final double? maxFontSize;
  final double? minFontSize;

  final MiniApp? miniApp;

  final void Function()? onTap;

  const CustomMiniAppsCard({
    super.key,
    this.width,
    this.height,
    this.iconHeight,
    this.iconWidth,
    this.titlesHeight,
    this.titlesWidth,
    this.backgroundColor,
    this.borderRadius,
    this.child,
    this.text,
    this.miniAppIcon,
    this.withCardEffect = false,
    this.boxShadow,
    required this.onTap,
    this.maxLines,
    this.maxFontSize,
    this.minFontSize,
    this.miniApp,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textScale = mediaQuery.textScaler.scale(1.0);
    // final screenWidth = mediaQuery.size.width;
    // Same as apps group card: title area responsive to font size
    // final defaultTitleWidth = (screenWidth * 0.25 * (0.92 + 0.16 * textScale.clamp(1.0, 1.5))).clamp(
    //   screenWidth * 0.24,
    //   screenWidth / 3 - 12,
    // );
    // final lines = maxLines ?? 3;
    // Height for title area scales with text size so bigger font gets more space; cap grows with scale
    // final maxTitleHeightForScale = (56.0 * textScale + 20).clamp(70.0, 115.0);
    // final minHeightForLines = (13.0 * 1.4 * lines * textScale + 10).clamp(36.0, maxTitleHeightForScale);
    // final defaultTitleHeight = (context.h(45) * textScale).clamp(minHeightForLines, maxTitleHeightForScale);
    final gap = (4.0 * textScale).clamp(0.0, 10.0);

    // final iconHeight = height ?? context.h(54.95);
    final gapHeight = (context.screenHeight * 0.01) + gap;
    // final defaultTitleH = titlesHeight ?? defaultTitleHeight;

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxH = constraints.maxHeight;
          final hasBoundedHeight = maxH.isFinite && maxH > 0;
          // final availableForTitle = (maxH - iconHeight - gapHeight).clamp(0.0, double.infinity);
          // For 3 lines, reserve at least minHeightForLines when there is room
          // final minTitleH = lines >= 3 ? minHeightForLines : 20.0;
          // final actualTitleHeight =
          //     (hasBoundedHeight
          //             ? availableForTitle.clamp(
          //                 math.min(minTitleH, availableForTitle),
          //                 defaultTitleH.clamp(0.0, availableForTitle),
          //               )
          //             : defaultTitleH)
          //         .toDouble();

          final column = Column(
            children: [
              SizedBox(
                height: context.h(70),
                width: context.w(70),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).disabledColor.withAlpha(90)),
                  ),
                  // elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
              /*
              Container(
                width: width ?? context.w(54.95),
                height: iconHeight,
                decoration: BoxDecoration(
                  borderRadius: borderRadius ?? BorderRadius.circular(16),
                  boxShadow: defaultShadow,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Color(0xFF01222E)
                        : Colors.white,
                    borderRadius: borderRadius ?? BorderRadius.circular(16),
                  ),
                  child: child,
                ),
              ),
              */
              SizedBox(height: gapHeight),
              SizedBox(
                width: context.screenWidth * 0.23,
                height: titlesHeight ?? (context.screenHeight * 0.05 * textScale),
                child: AutoSizeText(
                  text ?? "example",
                  textAlign: TextAlign.center,
                  maxLines: maxLines ?? 2,
                  maxFontSize: maxFontSize ?? 15,
                  minFontSize: minFontSize ?? 10,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    fontFamily: GeneralKey.appFontType,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
              ),
            ],
          );

          if (hasBoundedHeight) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxH),
              child: ClipRect(child: column),
            );
          }
          return column;
        },
      ),
    );
  }
}
