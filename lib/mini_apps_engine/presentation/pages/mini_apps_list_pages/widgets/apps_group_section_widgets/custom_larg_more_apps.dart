import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/apps_group_section_widgets/custom_number_of_apps_sub_card.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/apps_group_section_widgets/custom_sub_cards_of_larg_card.dart';
import 'package:flutter/material.dart';

class CustomLargMoreApps extends StatelessWidget {
  final double? width;
  final double? height;
  final double? iconWidth;
  final double? iconHeight;
  final double? textWidth;
  final double? textHeight;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  final String? text;
  final bool withCardEffect;
  final List<BoxShadow>? boxShadow;
  final void Function()? onTap;
  final List<MiniApp> apps;
  final int totalAppCount;

  const CustomLargMoreApps({
    super.key,
    this.width,
    this.height,
    this.textWidth,
    this.textHeight,
    this.iconHeight,
    this.iconWidth,
    this.backgroundColor,
    this.borderRadius,
    this.child,
    this.text,
    this.withCardEffect = false,
    this.boxShadow,
    required this.onTap,
    required this.apps,
    required this.totalAppCount,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final List<BoxShadow> defaultShadow = withCardEffect
        ? [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.08),
              blurRadius: 4.2,
              offset: const Offset(0, 1.05),
            ),
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.04),
              blurRadius: 0,
              spreadRadius: 0.52,
              offset: Offset.zero,
            ),
          ]
        : [];

    final random = Random();
    final displayApps = List<MiniApp>.from(apps)..shuffle(random);
    // final displayAppsToShow = displayApps.take(3).toList();
    //  final displayApps = apps.take(3).toList();
    final remainingCount = totalAppCount - 3;
    final isArabic = CommonFunctions.isAppAR;

    /// Helper: returns app cards aligned based on language
    List<Widget> buildTopRow() {
      final widgets = [
        displayApps.isNotEmpty
            ? CustomSubCardsOfLargCard(iconPath: displayApps[0].iconPath)
            : const EmptyCardWidget(),
        displayApps.length >= 2
            ? CustomSubCardsOfLargCard(iconPath: displayApps[1].iconPath)
            : const EmptyCardWidget(),
      ];
      return isArabic ? widgets.reversed.toList() : widgets;
    }

    List<Widget> buildBottomRow() {
      Widget thirdAppWidget = displayApps.length >= 3
          ? CustomSubCardsOfLargCard(iconPath: displayApps[2].iconPath)
          : const SizedBox(
              width: 64.37,
              height: 64.37,
            );

      Widget remainingWidget = remainingCount > 0
          ? CustomNumberOfAppsSubCard(count: remainingCount)
          : const SizedBox(
              width: 64.37,
              height: 64.37,
            );

      final widgets = isArabic
          ? [remainingWidget, thirdAppWidget]
          : [thirdAppWidget, remainingWidget];

      return CommonFunctions.isAppAR ? widgets.reversed.toList() : widgets;
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(16),
              boxShadow: boxShadow ?? defaultShadow,
            ),
            child: SizedBox(
              width: width ?? context.w(168),
              height: height ?? context.h(168),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.white,
                  borderRadius: borderRadius ?? BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                      children: buildTopRow(),
                    ),
                    SizedBox(height: context.screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                      children: buildBottomRow(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: context.screenHeight * 0.01),
          SizedBox(
            width: textWidth ?? context.screenWidth * 0.40,
            height: textHeight ?? context.screenHeight * 0.03,
            child: Center(
              child: AutoSizeText(
                text ?? "example",
                maxLines: 2,
                maxFontSize: 20,
                minFontSize: 10,
                overflow: TextOverflow.visible,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: const TextStyle(
                  color: Color(0XFF242424),
                  fontWeight: FontWeight.w700,
                  fontFamily: GeneralKey.appFontType,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyCardWidget extends StatelessWidget {
  const EmptyCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w(64.37),
      height: context.h(64.37),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
