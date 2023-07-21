import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

class MapDetailsField extends StatelessWidget {
  final String title;
  final String subTitle;

  const MapDetailsField(
      {super.key, required this.subTitle, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomTextWidget(
          title,
          fontSize: 15,
          fontWeight: AppFontWeight.bold,
          fontColor: AppColor.blackModern600Light,
        ),
        const CustomVerticalSpace(height: 8),
        CustomTextWidget(
          subTitle,
          fontSize: 14,
          fontWeight: AppFontWeight.semiBold,
          fontColor: AppColor.blackModern600Light,
        ),
      ]),
    );
  }
}
