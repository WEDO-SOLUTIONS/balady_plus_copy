import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../../data/model/excavations.dart';

class WhiteLandMapCard extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? subSubTitle;
  final String? municipality;
  final String? subMunicipality;
  final String? area;
  final String? parcelNo;
  final String? stageNo;

  final Function onClose;

  const WhiteLandMapCard(
      {super.key,
      this.subSubTitle,
      this.subTitle,
      this.title,
      this.municipality,
      this.subMunicipality,
      this.area,
      this.parcelNo,
      this.stageNo,
      required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 160,
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x1C77758D),
                blurRadius: 22,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextWidget(
                    "land_info".tr(),
                    fontColor: AppColor.blackModern800Light,
                    fontSize: 16,
                    fontWeight: AppFontWeight.bold,
                    maxLines: 1,
                  ),
                  CustomVerticalSpace(height: 8),
                  CustomTextWidget(
                    "${municipality},  ${subMunicipality}",
                    fontColor: AppColor.blackModern500Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.semiBold,
                    height: 1.3,
                    maxLines: 3,
                  ),
                  CustomVerticalSpace(height: 8),
                  CustomTextWidget(
                    area ?? "",
                    fontColor: AppColor.blackModern500Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.semiBold,
                    height: 1.3,
                    maxLines: 3,
                  ),
                  CustomVerticalSpace(height: 8),
                  CustomTextWidget(
                    "القطعة: ${parcelNo}",
                    fontColor: AppColor.blackModern500Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.semiBold,
                    height: 1.3,
                    maxLines: 3,
                  ),
                  CustomVerticalSpace(height: 8),
                  CustomTextWidget(
                    "المرحلة: ${stageNo}",
                    fontColor: AppColor.blackModern500Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.semiBold,
                    height: 1.3,
                    maxLines: 3,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    onClose();
                  },
                  child: CircleIcon(
                    icon: Icons.close,
                    circleSize: 24,
                    iconColor: AppColor.primary600Light,
                    backgroundColor: AppColor.geyser.withOpacity(0.4),
                    iconSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
