import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:flutter/material.dart';

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
    final List<BoxShadow> defaultShadow = withCardEffect
        ? [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.04),
              blurRadius: 0,
              spreadRadius: 0.5,
              offset: Offset.zero,
            ),
          ]
        : [];

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width ?? context.w(54.95),
            height: height ?? context.h(54.95),
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
          SizedBox(height: context.screenHeight * 0.01),
          SizedBox(
            width: titlesWidth ?? context.w(60),
            height: titlesHeight ?? context.h(45),
            child: AutoSizeText(
              text ?? "example",
              textAlign: TextAlign.center,
              maxLines: maxLines ?? 2,
              overflow: TextOverflow.ellipsis,
              maxFontSize: maxFontSize ?? 30,
              minFontSize: minFontSize ?? 10,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w400,
                fontFamily: GeneralKey.appFontType,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
