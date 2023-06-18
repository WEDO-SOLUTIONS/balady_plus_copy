import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomSvgIconWidget, CustomHorizontalSpace, CustomTextWidget;

class QrClassificationWidget extends StatelessWidget {
  final String? icon;
  final String text;

  const QrClassificationWidget({super.key, this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
              boxShadow: [],
              borderRadius: BorderRadius.circular(16),
              color: AppColor.white),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: EdgeInsetsDirectional.only(start: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColor.green60),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null && icon!.isNotEmpty) ...[
                  Image.asset(
                    icon!,
                    color: AppColor.primary600Light,
                    width: 20,
                    height: 20,
                  ),
                  const CustomHorizontalSpace(
                    width: 4,
                  )
                ],
                CustomTextWidget(
                  text,
                  fontColor: AppColor.blackModern600Light,
                  fontSize: 12,
                  fontWeight: AppFontWeight.bold,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
