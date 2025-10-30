import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';

class TextPoint extends StatelessWidget {
  final String textOne;
  final String textTow;

  const TextPoint({
    super.key,
    required this.textOne,
    required this.textTow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF5F7FA)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\u2022',
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.textPrimaryColor, height: 1.55),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    textOne,
                    maxLines: 3,
                    style: AppStyle.textRegularRomanStyle.copyWith(
                        color: AppColor.textPrimaryColor, height: 1.9),
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\u2022',
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.textPrimaryColor, height: 1.55),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    textTow,
                    maxLines: 3,
                    style: AppStyle.textRegularRomanStyle.copyWith(
                        color: AppColor.textPrimaryColor, height: 1.9),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      // Text(
      //   text,
      //   style: AppStyle.textRegularRomanStyle
      //       .copyWith(color: AppColor.textPrimaryColor),
      // ),
    );
  }
}
