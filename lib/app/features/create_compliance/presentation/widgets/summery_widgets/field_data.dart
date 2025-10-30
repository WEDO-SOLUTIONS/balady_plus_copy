import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

class FieldData extends StatelessWidget {
  final String title;
  final String? subTitle;
  final BorderRadius? radius;

  const FieldData({super.key, this.subTitle, required this.title, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Color(0x80E6EFEF),
          borderRadius: radius ?? BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: CustomTextWidget(
                  title,
                  fontColor: AppColor.primary700Light,
                  fontSize: 12,
                  maxLines: 10,
                  fontWeight: AppFontWeight.semiBold,
                ),
              ),
            ],
          ),
          if (subTitle != null) ...[
            const CustomVerticalSpace(height: 8),
            Row(
              children: [
                Flexible(
                  child: CustomTextWidget(
                    subTitle ?? "",
                    fontColor: AppColor.blackModern600Light,
                    fontSize: 16,
                    maxLines: 10,
                    textAlign: TextAlign.start,
                    fontWeight: AppFontWeight.semiBold,
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
