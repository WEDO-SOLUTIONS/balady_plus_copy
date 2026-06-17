import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
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

  final String categoryName;
  final String categoryIconPath;

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
    required this.categoryName,
    required this.categoryIconPath,
  });

  @override
  @override
  Widget build(BuildContext context) {
    // final List<BoxShadow> defaultShadow = withCardEffect
    //     ? [
    //         BoxShadow(color: const Color(0xFF000000).withOpacity(0.08), blurRadius: 4.2, offset: const Offset(0, 1.05)),
    //         BoxShadow(
    //           color: const Color(0xFF000000).withOpacity(0.04),
    //           blurRadius: 0,
    //           spreadRadius: 0.52,
    //           offset: Offset.zero,
    //         ),
    //       ]
    //     : [];

    // final random = Random();
    // final displayApps = List<MiniApp>.from(apps)..shuffle(random);
    // final displayAppsToShow = displayApps.take(3).toList();
    //  final displayApps = apps.take(3).toList();
    // final remainingCount = totalAppCount - 3;
    // final isArabic = CommonFunctions.isAppAR;

    /// Helper: returns app cards aligned based on language
    // List<Widget> buildTopRow() {
    //   final widgets = [
    //     displayApps.isNotEmpty ? CustomSubCardsOfLargCard(iconPath: displayApps[0].iconPath) : const EmptyCardWidget(),
    //     displayApps.length >= 2 ? CustomSubCardsOfLargCard(iconPath: displayApps[1].iconPath) : const EmptyCardWidget(),
    //   ];
    //   return isArabic ? widgets.reversed.toList() : widgets;
    // }

    // List<Widget> buildBottomRow() {
    //   Widget thirdAppWidget = displayApps.length >= 3
    //       ? CustomSubCardsOfLargCard(iconPath: displayApps[2].iconPath)
    //       : const SizedBox(width: 64.37, height: 64.37);

    //   Widget remainingWidget = remainingCount > 0
    //       ? CustomNumberOfAppsSubCard(count: remainingCount)
    //       : const SizedBox(width: 64.37, height: 64.37);

    //   final widgets = isArabic ? [remainingWidget, thirdAppWidget] : [thirdAppWidget, remainingWidget];

    //   return CommonFunctions.isAppAR ? widgets.reversed.toList() : widgets;
    // }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            width: context.w(117),
            height: context.h(98),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              color: Theme.of(context).primaryColorLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomNetworkImageWidget(
                    categoryIconPath,
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
                      categoryName,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center, // Good practice for grid items
                      style: const TextStyle(fontFamily: GeneralKey.appFontType, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyCardWidget extends StatelessWidget {
  const EmptyCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w(64.37),
      height: context.h(64.37),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
