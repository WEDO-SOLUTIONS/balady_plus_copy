import 'dart:math' as math;

import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

//!
class AppsGroupMiniAppsCardWidgets extends StatelessWidget {
  final double? width;
  final double? height;

  final double? iconWidth;
  final double? iconHeight;

  final bool? isTextRemove;

  final String? title;
  final String iconPath;

  final double? radius;

  final void Function()? onTap;

  final bool isActive;
  const AppsGroupMiniAppsCardWidgets({
    super.key,
    this.width,
    this.height,
    this.iconHeight,
    this.iconWidth,
    this.isTextRemove = false,
    this.title,
    required this.iconPath,
    this.onTap,
    this.radius,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final textScale = mediaQuery.textScaler.scale(1.0);
    // Title area: scale with accessibility text size so 3 lines fit (13*1.4*3≈55 base)
    final baseTitleHeight = (screenHeight * 0.062).clamp(40.0, 57.0);
    final titleHeight = (baseTitleHeight * textScale).clamp(40.0, 85.0);
    // Widen title when font is bigger so words don't break with 1–2 letters on the next line
    final cellWidth = screenWidth / 3 - 12;
    final titleWidth = (screenWidth * 0.25 * (0.92 + 0.16 * textScale.clamp(1.0, 1.5))).clamp(
      screenWidth * 0.24,
      cellWidth,
    );

    final iconMaxHeight = height ?? context.h(87.12268829345703);
    final cardWidth = width ?? context.w(87.12268829345703);

    return GestureDetector(
      onTap: onTap,
      child: isTextRemove == false
          ? LayoutBuilder(
              builder: (context, parentConstraints) {
                final maxTotalHeight = parentConstraints.maxHeight;
                final hasBoundedHeight = maxTotalHeight.isFinite && maxTotalHeight > 0;

                // Responsive to text scale: gap between icon and title grows with font size
                final verticalGap = (4.0 * textScale).clamp(0.0, 10.0);
                final minIconHeight = 56.0;
                // Title area scales with font: 13*1.4*3 ≈ 54.6 + buffer for metrics at large scale
                final minTitleHeightFor3Lines = (56.0 * textScale + 14.0).clamp(32.0, double.infinity);
                final double iconMaxActual;
                final double titleMaxActual;
                if (hasBoundedHeight) {
                  final spaceForIconAndTitle = maxTotalHeight - verticalGap;
                  final maxTitleAllowed = math.max(0.0, spaceForIconAndTitle - minIconHeight);
                  titleMaxActual = math
                      .min(minTitleHeightFor3Lines, math.min(titleHeight, maxTitleAllowed))
                      .clamp(32.0, maxTitleAllowed);
                  iconMaxActual = math.max(minIconHeight, spaceForIconAndTitle - titleMaxActual);
                } else {
                  iconMaxActual = iconMaxHeight;
                  titleMaxActual = titleHeight;
                }

                final iconSection = Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.01),
                  child: SizedBox(
                    width: cardWidth,
                    height: iconMaxActual,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF012F41) : Color(0XFFE5EBED),
                        borderRadius: BorderRadius.circular(radius ?? 22),
                      ),
                      child: Center(
                        child: CustomNetworkImageWidget(
                          iconPath,
                          isVerifyingKey: true,
                          imageWidth: iconWidth ?? context.w(60),
                          imageHeight: iconHeight ?? context.h(60),
                          placeHolderWidget: SvgPicture.asset(ImagePath.calendarBackground),
                        ),
                      ),
                    ),
                  ),
                );

                final titleSection = SizedBox(
                  height: titleMaxActual,
                  width: titleWidth,
                  child: ClipRect(
                    child: Text(
                      title ?? "example",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: GeneralKey.appFontType,
                        height: 1.4,
                      ),
                    ),
                  ),
                );

                if (hasBoundedHeight) {
                  return SizedBox(
                    height: maxTotalHeight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        iconSection,
                        if (verticalGap > 0) SizedBox(height: verticalGap),
                        titleSection,
                      ],
                    ),
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 2,
                      fit: FlexFit.loose,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: iconMaxActual),
                        child: iconSection,
                      ),
                    ),
                    if (verticalGap > 0) SizedBox(height: verticalGap),
                    Flexible(flex: 1, fit: FlexFit.loose, child: titleSection),
                  ],
                );
              },
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.01),
              child: SizedBox(
                width: width ?? context.w(87.12268829345703),
                height: height ?? context.h(87.12268829345703),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isActive && Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).primaryColorLight
                        : isActive == false && Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).colorScheme.onSurface.withAlpha(10)
                        : Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(radius ?? 22),
                  ),
                  child: Center(
                    child: CustomNetworkImageWidget(
                      iconPath,
                      // sso: true,
                      // ssoAuth: true,
                      isVerifyingKey: true,
                      imageWidth: iconWidth ?? context.w(60),
                      imageHeight: iconHeight ?? context.h(60),
                      placeHolderWidget: SvgPicture.asset(ImagePath.calendarBackground),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
