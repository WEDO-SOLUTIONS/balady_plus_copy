import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class RateAndReviewWidget extends StatelessWidget {
  final double rate;
  final int review;
  final double fontSize;

  const RateAndReviewWidget(
      {Key? key, required this.rate, required this.review, this.fontSize = 13})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextWidget(
          rate.toString(),
          fontColor: AppColor.black400,
          fontWeight: AppFontWeight.bold,
          fontSize: fontSize,
          fontFamily: Constants.lucidaGrandFontType,
        ),
        const CustomHorizontalSpace(width: 6),
        Padding(
          padding: const EdgeInsets.only(bottom: 2.5),
          child: Image.asset(
            IconPath.qrStarsIcon,
            width: fontSize == 13 ? 12.0 : 10,
            height: fontSize == 13 ? 12.0 : 10,
          ),
        ),
        const CustomHorizontalSpace(width: 6),
        const CustomTextWidget(
          "|",
          fontColor: AppColor.black400,
          fontWeight: AppFontWeight.medium,
          fontSize: 13,
        ),
        CustomTextWidget(
          review.toString() + "  ",
          fontColor: AppColor.black400,
          fontWeight: AppFontWeight.bold,
          fontSize: fontSize,
          fontFamily: Constants.lucidaGrandFontType, //MM
        ),
        CustomTextWidget(
          ("review").tr(),
          fontColor: AppColor.black400,
          fontWeight: AppFontWeight.regular,
          fontSize: fontSize,
        ),
      ],
    );
  }
}

class RateAndReviewWidgetWithoutDivider extends StatelessWidget {
  final double rate;
  final int review;

  const RateAndReviewWidgetWithoutDivider(
      {Key? key, required this.rate, required this.review})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2.5),
          child: Image.asset(
            IconPath.qrStarsIcon,
            width: 13,
            height: 13,
          ),
        ),
        const CustomHorizontalSpace(width: 6),
        CustomTextWidget(
          rate.toString(),
          fontColor: AppColor.black400,
          fontWeight: AppFontWeight.regular,
          fontSize: 16,
          fontFamily: Constants.lucidaGrandFontType,
        ),
        const Spacer(),
        CustomTextWidget(
          review.toString() + "  ",
          fontColor: AppColor.black400,
          fontWeight: AppFontWeight.regular,
          fontSize: 13,
          fontFamily: Constants.lucidaGrandFontType,
        ),
        CustomTextWidget(
          ("review").tr(),
          fontColor: AppColor.black400,
          fontWeight: AppFontWeight.medium,
          fontSize: 13,
        ),
      ],
    );
  }
}
