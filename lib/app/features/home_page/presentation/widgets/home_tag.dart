import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppStyle;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget;

class HomeTag extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;

  const HomeTag({
    super.key,
    required this.title,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CustomTextWidget(
        title,
        textStyle: AppStyle.tagStyle.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
