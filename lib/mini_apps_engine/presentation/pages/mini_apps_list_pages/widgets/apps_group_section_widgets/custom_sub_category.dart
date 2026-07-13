import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/apps_group_section_widgets/custom_larg_more_apps.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/apps_group_section_widgets/custom_nums_sub_category.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/apps_group_section_widgets/custom_sub_cards_sub_category.dart';
import 'package:flutter/material.dart';

//!
class CustomSubCategory extends StatelessWidget {
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
  final List<BoxShadow>? boxShadow;
  final void Function()? onTap;
  final List<MiniApp> apps;
  final int totalAppCount;

  const CustomSubCategory({
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
    this.boxShadow,
    required this.onTap,
    required this.apps,
    required this.totalAppCount,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final random = Random();
    final displayApps = List<MiniApp>.from(apps)..shuffle(random);
    final remainingCount = totalAppCount - 3;
    final isArabic = CommonFunctions.isAppAR;

    // / Helper: returns app cards aligned based on language
    List<Widget> buildTopRow() {
      final widgets = [
        displayApps.isNotEmpty
            ? CustomSubCardsOfSubCategory(iconPath: displayApps[0].iconPath)
            : const EmptyCardWidget(),
        displayApps.length >= 2
            ? CustomSubCardsOfSubCategory(iconPath: displayApps[1].iconPath)
            : const EmptyCardWidget(),
      ];
      return isArabic ? widgets.reversed.toList() : widgets;
    }

    List<Widget> buildBottomRow() {
      Widget thirdAppWidget = displayApps.length >= 3
          ? CustomSubCardsOfSubCategory(iconPath: displayApps[2].iconPath)
          : const SizedBox(width: 36, height: 36);

      Widget remainingWidget = remainingCount > 0
          ? CustomNumberOfSubs(count: remainingCount)
          : const SizedBox(width: 36, height: 36);

      final widgets = isArabic ? [remainingWidget, thirdAppWidget] : [thirdAppWidget, remainingWidget];

      return CommonFunctions.isAppAR ? widgets.reversed.toList() : widgets;
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            width: context.w(100),
            height: context.h(100),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).colorScheme.onSurface.withAlpha(13)
                  : Theme.of(context).primaryColorLight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                    children: buildTopRow(),
                  ),
                  SizedBox(height: context.screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                    children: buildBottomRow(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: context.screenWidth * 0.25,
            // height: context.screenHeight * 0.02,
            child: AutoSizeText(
              maxLines: 3,
              maxFontSize: 14,
              minFontSize: 10,
              text ?? "",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center, // Good practice for grid items
              style: const TextStyle(fontFamily: GeneralKey.appFontType, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}



 /* 
               Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomNetworkImageWidget(
                    apps.first.iconPath,
                    isVerifyingKey: true,
                    imageFit: BoxFit.contain,
                    imageWidth: context.w(51),
                    imageHeight: context.h(51),
                  ),
                  // SizedBox(height: context.screenHeight * 0.02),
                  SizedBox(
                    width: context.screenWidth * 0.25,
                    height: context.screenHeight * 0.02,
                    child: AutoSizeText(
                      maxLines: 3,
                      maxFontSize: 14,
                      minFontSize: 10,
                      text ?? "",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center, // Good practice for grid items
                      style: const TextStyle(fontFamily: GeneralKey.appFontType, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              */





               /*
      Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.01),
            child: DecoratedBox(
              decoration: BoxDecoration(borderRadius: borderRadius ?? BorderRadius.circular(16)),
              child: SizedBox(
                width: width ?? context.w(87),
                height: height ?? context.h(87),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF012F41)
                        : const Color(0XFFE5EBED),
                    borderRadius: borderRadius ?? BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                          children: buildTopRow(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                          children: buildBottomRow(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: context.screenHeight * 0.03,
            width: context.screenWidth * 0.40,
            child: Text(
              text ?? "example",
              maxLines: 2,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                //   color: Color(0XFF1E2A36),
                fontFamily: GeneralKey.appFontType,
                height: 1.4,
              ),
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            ),
          ),
          
        ],
      ),
      */