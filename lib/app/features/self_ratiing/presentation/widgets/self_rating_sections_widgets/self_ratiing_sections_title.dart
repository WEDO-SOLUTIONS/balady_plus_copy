import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SelfRatingSectionsTitle extends StatelessWidget {
  const SelfRatingSectionsTitle({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextWidget(
          title,
          textStyle: AppStyle.selfRatingTitleStyle,
        ),
        CustomTextWidget(
          'review_title_subtitle'.tr(),
          maxLines: 4,
          textStyle: AppStyle.selfRatingSubtitleStyle,
        )
      ],
    );
  }
}
