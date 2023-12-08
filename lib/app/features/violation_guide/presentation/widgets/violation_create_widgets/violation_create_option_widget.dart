import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

class ViolationCreateOptionWidget extends StatelessWidget {
  const ViolationCreateOptionWidget({
    super.key,
    required this.optionTitle,
    required this.onPressed,
  });
  final String optionTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 141,
        decoration: BoxDecoration(
          color: AppColor.primary100Light,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextWidget(
                optionTitle,
                fontColor: AppColor.primary900Light,
                fontWeight: AppFontWeight.bold,
                fontSize: 14,
                textAlign: TextAlign.center,
                maxLines: 3,
                height: 1.4,
              ),
            ]),
      ),
    );
  }
}
