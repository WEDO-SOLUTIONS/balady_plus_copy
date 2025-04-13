import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

class ReadOnlyField extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Color? subTitleColor;
  final bool showSpace;
  final double? hieght;
  final BoxDecoration? decoration;

  ReadOnlyField(
      {super.key,
        this.subTitle,
        required this.title,
        this.subTitleColor,
        this.showSpace = true,
        this.decoration,
        this.hieght = 55,
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          title,
          fontColor: AppColor.blackModern700Light,
          fontSize: 16,
          fontWeight: AppFontWeight.bold,
        ),
        const CustomVerticalSpace(height: 16),
        Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            height: hieght,
            decoration:decoration??  BoxDecoration(
                color: Colors.transparent,
                border:
                Border.all(color: AppColor.blackModern300Light, width: 2),
                borderRadius: BorderRadius.circular(6)),
            child: CustomTextWidget(
              subTitle ?? "",
              fontColor: subTitleColor ?? AppColor.blackModern700Light,
              fontSize: 14,
              maxLines: 20,
              textAlign: TextAlign.start,
              fontWeight: AppFontWeight.semiBold,
            )),
        if (showSpace) const CustomVerticalSpace(height: 16),
      ],
    );
  }
}
