import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../shared/circle_icon.dart';

class WhiteLandMapCard extends StatelessWidget {
  final String? municipality;
  final String? streetName;
  final String? parcelNo;
  final String? stageNo;

  final Function onClose;

  const WhiteLandMapCard({
    super.key,
    this.municipality,
    this.streetName,
    this.parcelNo,
    this.stageNo,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 160,
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            shadows: const [BoxShadow(color: Color(0x1C77758D), blurRadius: 22, offset: Offset(0, 4), spreadRadius: 0)],
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
                  const CustomVerticalSpace(height: 8),
                  CustomTextWidget(
                    "$municipality,  $streetName",
                    fontColor: AppColor.blackModern500Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.semiBold,
                    height: 1.3,
                    maxLines: 3,
                  ),
                  const CustomVerticalSpace(height: 8),
                  CustomTextWidget(
                    "parcel_no".tr().replaceAll("{}", parcelNo ?? ""),
                    fontColor: AppColor.blackModern500Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.semiBold,
                    height: 1.3,
                    maxLines: 3,
                  ),
                  const CustomVerticalSpace(height: 8),
                  CustomTextWidget(
                    "stage_no".tr().replaceAll("{}", stageNo ?? ""),
                    fontColor: AppColor.blackModern500Light,
                    fontSize: 12,
                    fontWeight: AppFontWeight.semiBold,
                    height: 1.3,
                    maxLines: 3,
                  ),
                ],
              ),
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: GestureDetector(
                  onTap: () {
                    onClose();
                  },
                  child: CircleIcon(
                    icon: Icons.close,
                    circleSize: 24,
                    iconColor: AppColor.primary600Light,
                    backgroundColor: AppColor.geyser.withValues(alpha: 0.4),
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
