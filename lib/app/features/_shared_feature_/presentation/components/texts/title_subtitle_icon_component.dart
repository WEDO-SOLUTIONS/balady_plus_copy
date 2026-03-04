import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppFontWeight, AppStyle, WidgetConversion;
import '../../../shared_feature_exports.dart' show CustomAutoSizeTextWidget, CustomTextWidget, DrawIconBasedTypeWidget;

class TitleSubtitleIconComponent extends StatelessWidget {
  final double? componentHeight;
  final double? componentWidth;

  final Object icon;
  final double iconSize;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  final double iconTitleSubtitleTweenSpace;

  final String title;
  final TextStyle? titleStyle;

  final double titleSubtitleTweenSpace;

  final String subtitle;
  final TextStyle? subtitleStyle;
  final int maxLines;
  const TitleSubtitleIconComponent({
    super.key,
    this.componentHeight,
    this.componentWidth,
    required this.icon,
    this.iconSize = 24.0,
    this.iconColor = AppColor.gray,
    this.iconBackgroundColor = AppColor.white,
    this.iconTitleSubtitleTweenSpace = 12.0,
    required this.title,
    this.titleStyle,
    this.titleSubtitleTweenSpace = 3.0,
    required this.subtitle,
    this.subtitleStyle,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: componentHeight,
      width: componentWidth,
      child: Row(
        children: [
          // Icon widget
          Container(
            width: iconSize,
            height: iconSize,
            padding: const EdgeInsets.all(4.0),
            decoration: decoration,
            child: DrawIconBasedTypeWidget(
              icon: icon,
              iconSize: iconSize,
              iconColor: iconColor,
            ),
          ),
          //? Title & Subtitle widgets
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title widget
                CustomTextWidget(
                  title,
                  textStyle: titleStyle ?? _titleStyle,
                ),
                // Subtitle widget
                CustomAutoSizeTextWidget(
                  subtitle,
                  textStyle: subtitleStyle ?? _subtitleStyle,
                  maxLines: maxLines,
                  maxFontSize: 16.0,
                  minFontSize: 10.0,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ].addPadding(bottom: titleSubtitleTweenSpace),
            ),
          ),
        ].addPadding(end: iconTitleSubtitleTweenSpace),
      ),
    );
  }

  Decoration get decoration => BoxDecoration(
        color: iconBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      );

  TextStyle get _titleStyle => AppStyle.mainTextThirdStyle.copyWith(fontSize: 13.0);
  TextStyle get _subtitleStyle => AppStyle.mainTextSecondaryStyle.copyWith(
        fontSize: 16.0,
        fontWeight: AppFontWeight.regular.fontWeight,
        height: 1.1,
      );
}
