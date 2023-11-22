import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';

import '../../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class ReplyBadgeWidget extends StatelessWidget {
  final String text;
  const ReplyBadgeWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: Color(0xFFffe6f7d4)),
      child: CustomTextWidget(
        text,
        fontSize: 13,
        fontWeight: AppFontWeight.regular,
        fontColor: Color(0xFFff4f8a0f),
        maxLines: 1,
        textOverflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
      ),
    );
  }
}
