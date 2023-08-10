import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../../data/model/excavations.dart';

class LandMapCard extends StatelessWidget {
  final String? BLOCK_ID;
  final String? SUBDIVISIONPARCELNUMBER;
  final String? SUBDIVISIONPLAN_ID;
  final String? municipality;
  final String? subMunicipality;

  final Function onClose;

  const LandMapCard(
      {super.key,
      this.municipality,
      this.subMunicipality,
      this.SUBDIVISIONPARCELNUMBER,
      this.SUBDIVISIONPLAN_ID,
      this.BLOCK_ID,
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
                    'map_info'.tr(),
                    fontColor: AppColor.blackModern800Light,
                    fontSize: 16,
                    fontWeight: AppFontWeight.bold,
                    maxLines: 1,
                  ),
                  CustomVerticalSpace(height: 8),
                  CustomTextWidget(
                    "${municipality}, ${subMunicipality}",
                    fontColor: AppColor.blackModern500Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.semiBold,
                    height: 1.3,
                    maxLines: 3,
                  ),
                  CustomVerticalSpace(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        "المخطط: ${SUBDIVISIONPLAN_ID}",
                        fontColor: AppColor.blackModern500Light,
                        fontSize: 12,
                        fontWeight: AppFontWeight.semiBold,
                        height: 1.3,
                        maxLines: 3,
                      ),
                      CustomTextWidget(
                        "البلوك: ${BLOCK_ID}",
                        fontColor: AppColor.blackModern500Light,
                        fontSize: 12,
                        fontWeight: AppFontWeight.semiBold,
                        height: 1.3,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  CustomVerticalSpace(
                    height: 24,
                  ),
                  CustomTextWidget(
                    "القطعة: ${SUBDIVISIONPARCELNUMBER}",
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
