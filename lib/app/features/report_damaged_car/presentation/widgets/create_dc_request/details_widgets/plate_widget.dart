import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class PlateWidget extends StatelessWidget {
  final String? arLetters;
  final String? enLetters;
  final String? arNumbers;
  final String? enNumbers;
  const PlateWidget(
      {super.key,
      this.arLetters,
      this.enLetters,
      this.arNumbers,
      this.enNumbers});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 230,
          height: 132,
          decoration: BoxDecoration(
              color: AppColor.white, borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 156,
                height: 80,
                decoration: BoxDecoration(
                    color: AppColor.white,
                    border: Border.all(
                      color: AppColor.black,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    PlateLogoSection(),
                    DrawLineWidget(
                      lineWidth: 1.5,
                      lineHeight: double.infinity,
                      lineColor: AppColor.black,
                    ),
                    PlateNumberSection(
                      arValue: arLetters ?? "",
                      enValue: enLetters ?? "",
                      fontWeight: AppFontWeight.bold,
                      fontSize: 16,
                    ),
                    DrawLineWidget(
                      lineWidth: 1.5,
                      lineHeight: double.infinity,
                      lineColor: AppColor.black,
                    ),
                    PlateNumberSection(
                      arValue: arNumbers ?? "",
                      enValue: enNumbers ?? "",
                      fontWeight: AppFontWeight.medium,
                      fontSize: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PlateLogoSection extends StatelessWidget {
  const PlateLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      color: Color(0xFF666666),
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomSvgIconWidget(
            IconPath.ksaFlag,
            iconHeight: 21,
            iconWidth: 16,
          ),
          CustomSvgIconWidget(
            IconPath.ksaWord,
            iconHeight: 22,
            iconWidth: 5,
          ),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
                color: AppColor.black, borderRadius: BorderRadius.circular(3)),
          ),
        ],
      ),
    );
  }
}

class PlateNumberSection extends StatelessWidget {
  final String arValue;
  final String enValue;
  final AppFontWeight fontWeight;
  final double fontSize;
  const PlateNumberSection(
      {super.key,
      required this.arValue,
      required this.enValue,
      required this.fontWeight,
      required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomTextWidget(
            arValue,
            fontColor: AppColor.black,
            fontWeight: fontWeight,
            fontSize: fontSize,
            textAlign: TextAlign.center,
          ),
          DrawLineWidget(
            lineWidth: double.infinity,
            lineHeight: 1.5,
            lineColor: AppColor.black,
          ),
          CustomTextWidget(
            enValue,
            fontColor: AppColor.black,
            fontWeight: fontWeight,
            fontSize: fontSize,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
