import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';

class LabelIconComponent extends StatelessWidget {
  final String text;
  final String? icon;
  final double? iconSize;
  const LabelIconComponent(
      {required this.text, this.icon, this.iconSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 6.0),
            child: CustomSvgIconWidget(
              icon!,
              iconSize: iconSize,
            ),
          ),
        CustomTextWidget(
          text,
          fontWeight: AppFontWeight.bold,
          fontSize: 15,
          fontColor: AppColor.blackModern600Light,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
