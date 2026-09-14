import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../shared_feature_exports.dart' show CustomTextWidget;

class CardParameter extends StatelessWidget {
  final String title;
  final String value;
  final Color? bgColor;
  final int? lines;
  const CardParameter({super.key, required this.title, required this.value, this.bgColor, this.lines});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: bgColor ?? AppColor.primary50Light50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(title, textStyle: AppStyle.personalInfoParameterTitleTextStyle),
          const SizedBox(height: 8),
          CustomTextWidget(value, maxLines: lines, textStyle: AppStyle.personalInfoParameterValueTextStyle),
        ],
      ),
    );
  }
}
