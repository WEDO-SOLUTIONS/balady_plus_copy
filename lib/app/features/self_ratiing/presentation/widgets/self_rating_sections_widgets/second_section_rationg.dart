import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_sections_widgets/rating_section_widget.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_sections_widgets/self_ratiing_sections_title.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
/*
class SecondSectionRatingWidget extends StatelessWidget {
  const SecondSectionRatingWidget({
    super.key,
    required this.onPressed,
  });
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    List<String> ratingText = [
      'review2_section1'.tr(),
      'review2_section2'.tr(),
      'review2_section3'.tr(),
      'review2_section4'.tr(),
    ];
    return Column(
      children: [
        SelfRatingSectionsTitle(
          title: 'review_title_2'.tr(),
        ),
        SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 450,
          child: ListView.builder(
            itemCount: ratingText.length,
            itemBuilder: (context, index) {
              return SelfRatingSectionWidget(
                ratingText: ratingText[index],
              );
            },
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
        ElevatedButtonWidget.next(
          onPressed: onPressed,
        ),
      ],
    );
  }
}
*/
