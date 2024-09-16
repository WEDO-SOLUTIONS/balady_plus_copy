import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';

class CustomTextComponent extends StatelessWidget {
  final String text;

  const CustomTextComponent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF5F7FA)),
      child: Text(
        text,
        style: AppStyle.textRegularRomanStyle
            .copyWith(color: AppColor.textPrimaryColor),
      ),
    );
  }
}
