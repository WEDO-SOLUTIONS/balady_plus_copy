import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, trans;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomTextWidget;
import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  final String text;
  final int maxLines;
  final double? textSize;

  const TagWidget(
      {Key? key, required this.text, this.maxLines = 1, this.textSize = 13})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: textSize == 13 ? 12 : 8, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: Color(0xFFffe6f7d4)),
      child: CustomTextWidget(
        text,
        fontSize: textSize,
        fontWeight: AppFontWeight.regular,
        fontColor: Color(0xFFff4f8a0f),
        maxLines: maxLines,
        textOverflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
      ),
    );
  }
}
