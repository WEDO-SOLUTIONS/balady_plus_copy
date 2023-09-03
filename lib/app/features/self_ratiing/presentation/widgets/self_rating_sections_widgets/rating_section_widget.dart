import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/radio_custom.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_sections_widgets/self_rating_radio_option.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../data/models/self_rating_item.dart';

class SelfRatingSectionWidget extends StatelessWidget {
  const SelfRatingSectionWidget(
      {super.key, required this.item, required this.onSelect});
  final SelfRatingItem item;
  final Function onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 311,
                child: Image.asset(
                  item.image,
                )),
            SizedBox(
              height: 8,
            ),
            CustomTextWidget(
              item.condition,
              maxLines: 5,
              textAlign: TextAlign.right,
              textStyle: AppStyle.selfRatingSectionTextStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingSingleRatioOption(
                  value: 1,
                  title: 'clauses_option1'.tr(),
                  height: 54,
                  selectdValue: item.compliance == true ? 1 : null,
                  titleStyle: AppStyle.complianceClausesOptionStyle,
                  onChanged: (int value) {
                    onSelect(true);
                  },
                ),
                const SizedBox(
                  width: 6,
                ),
                RatingSingleRatioOption(
                  title: 'clauses_option2'.tr(),
                  value: 2,
                  height: 54,
                  selectdValue: item.compliance == false ? 2 : null,
                  titleStyle: AppStyle.complianceClausesOptionStyle,
                  onChanged: (int value) {
                    onSelect(false);
                  },
                ),
              ],
            )
          ]),
    );
  }
}
