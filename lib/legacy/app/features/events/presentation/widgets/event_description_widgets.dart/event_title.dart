import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

class EventsTitleWidget extends StatelessWidget {
  const EventsTitleWidget({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          title,
          textStyle: AppStyle.eventsTitleSectionStyle,
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
