import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/radio_custom.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_sections_widgets/self_rating_radio_option.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

final List<String> imgList = [
  ImagePath.violationImage,
  ImagePath.violationImage,
  ImagePath.violationImage,
  ImagePath.violationImage,
];

class SelfRatingSectionWidget extends StatefulWidget {
  const SelfRatingSectionWidget({
    super.key,
    required this.ratingText,
  });
  final String ratingText;

  @override
  State<SelfRatingSectionWidget> createState() =>
      _SelfRatingSectionWidgetState();
}

class _SelfRatingSectionWidgetState extends State<SelfRatingSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
                  child: Swiper(
                    itemCount: imgList.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        imgList[index],
                      );
                    },
                  )),
              SizedBox(
                height: 8,
              ),
              CustomTextWidget(
                widget.ratingText,
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
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.05,
                    titleStyle: AppStyle.complianceClausesOptionStyle,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  RatingSingleRatioOption(
                    title: 'clauses_option2'.tr(),
                    value: 2,
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.05,
                    titleStyle: AppStyle.complianceClausesOptionStyle,
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
