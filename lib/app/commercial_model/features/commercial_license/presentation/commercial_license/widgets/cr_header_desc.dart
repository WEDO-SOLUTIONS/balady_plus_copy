import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';

class CRHeaderDesc extends StatelessWidget {
  final String header;
  final String? desc;
  final double verticalSpace;
  final int? maxLines;
  final double? textHeight;

  const CRHeaderDesc(
      {Key? key,
      required this.header,
      this.desc,
      this.textHeight,
      this.verticalSpace = 24,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomVerticalSpace(height: verticalSpace),
        CustomTextWidget(
          header,
          fontColor: AppColor.black,
          fontSize: 20.0,
          fontWeight: AppFontWeight.bold,
          textAlign: TextAlign.start,
          maxLines: 2,
          textOverflow: TextOverflow.ellipsis,
        ),
        const CustomVerticalSpace(height: 8),
        CustomTextWidget(
          desc ?? "",
          fontColor: AppColor.blackModern500Light,
          fontSize: 14.0,
          maxLines: maxLines,
          height: textHeight,
          fontWeight: AppFontWeight.medium,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
