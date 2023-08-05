import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/paths/icon_paths.dart';

class SuccessRatingDialog extends StatelessWidget {
  final String title;
  final String desc;

  const SuccessRatingDialog(
      {super.key, required this.desc, required this.title});

  @override
  Widget build(BuildContext context) {
    return BottomSheetWithActions(
      title: "",
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              IconPath.successIcon,
              width: 140,
            ),
            CustomVerticalSpace(height: 16),
            CustomTextWidget(
              title,
              fontColor: Color(0xFF292929),
              fontWeight: AppFontWeight.bold,
              fontSize: 20,
              maxLines: 30,
            ),
            CustomVerticalSpace(height: 8),
            CustomTextWidget(
              desc,
              fontColor: AppColor.blackModern500Light,
              fontWeight: AppFontWeight.bold,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
