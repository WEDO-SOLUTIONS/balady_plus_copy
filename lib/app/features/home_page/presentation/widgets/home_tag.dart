import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../_shared_feature_/shared_feature_exports.dart' show CustomTextWidget, DrawIconBasedTypeWidget;

class HomeTag extends StatelessWidget {
  final String title;
  final Color? color;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final Object? icon;
  final Color? iconColor;
  final double? height;
  final bool selected;

  const HomeTag({
    super.key,
    required this.title,
    this.color,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.icon,
    this.iconColor,
    this.height,
    this.selected = false,
  }) : assert((color == null && backgroundColor != null) || (color != null && backgroundColor == null),
            "can't choose color and backgroundColor at the same time");
  @override
  Widget build(BuildContext context) {
    final backgroundColor = this.backgroundColor ?? (selected ? color : AppColor.blackModern50Light);
    final textColor = this.textColor ?? (selected ? AppColor.blackModern50Light : AppColor.blackModern600Light);
    final iconColor = this.iconColor ?? (selected ? AppColor.blackModern50Light : color);

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (icon != null)
            DrawIconBasedTypeWidget(
              icon: icon!,
              iconColor: iconColor,
            ),
          if (icon != null) const SizedBox(width: 5),
          CustomTextWidget(
            title,
            textStyle: AppStyle.tagStyle.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
