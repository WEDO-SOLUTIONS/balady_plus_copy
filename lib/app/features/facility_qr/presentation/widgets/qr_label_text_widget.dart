import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';

class QRLabelTextWidget extends StatelessWidget {
  final String text;
  const QRLabelTextWidget({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      text,
      fontWeight: AppFontWeight.bold,
      fontSize: 16,
      fontColor: AppColor.black,
      textAlign: TextAlign.start,
    );
  }
}
