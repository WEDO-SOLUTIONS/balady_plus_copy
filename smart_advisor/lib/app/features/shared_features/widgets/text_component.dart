import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';

class TextComponent extends StatelessWidget {
  final String title;
  final String Subtitle;
  const TextComponent({super.key, required this.title, required this.Subtitle});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: AppColor.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
              Text(
                Subtitle,
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.textSecondaryColor, fontSize: 14),
              ),
            ],
          )),
    );
  }
}
