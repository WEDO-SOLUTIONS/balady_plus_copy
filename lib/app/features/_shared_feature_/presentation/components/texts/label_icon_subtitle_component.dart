import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';

class LabelIconSubtitleComponent extends StatelessWidget {
  final String text;
  final String? subtitle;
  final Widget? subWidget;
  final String? icon;
  final double? iconSize;
  final Function? onPress;
  final EdgeInsetsDirectional? padding;

  const LabelIconSubtitleComponent({
    required this.text,
    this.subtitle,
    this.subWidget,
    this.icon,
    this.onPress,
    this.iconSize,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [], borderRadius: BorderRadius.circular(16), color: AppColor.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 6.0),
                  child: CustomSvgIconWidget(icon!, iconSize: iconSize),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextWidget(
                      text,
                      fontWeight: AppFontWeight.bold,
                      fontSize: 15,
                      fontColor: AppColor.blackModern600Light,
                      textAlign: TextAlign.start,
                    ),
                    CustomVerticalSpace(height: 8),
                    if (subtitle != null)
                      GestureDetector(
                        onTap: () {
                          if (onPress != null) {
                            onPress!();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: CustomTextWidget(
                            subtitle ?? "",
                            fontWeight: AppFontWeight.bold,
                            fontSize: 15,
                            fontColor: AppColor.blackModern500Light,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          ?subWidget,
        ],
      ),
    );
  }
}
