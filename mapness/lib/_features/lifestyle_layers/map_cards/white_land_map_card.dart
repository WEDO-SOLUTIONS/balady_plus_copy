import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';

class WhiteLandMapCard extends StatelessWidget {

  const WhiteLandMapCard(
      {required this.onClose, super.key,
      this.subSubTitle,
      this.subTitle,
      this.title,
      this.municipality,
      this.subMunicipality,
      this.area,
      this.parcelNo,
      this.stageNo,});
  final String? title;
  final String? subTitle;
  final String? subSubTitle;
  final String? municipality;
  final String? subMunicipality;
  final String? area;
  final String? parcelNo;
  final String? stageNo;

  final Function()? onClose;

  @override
  Widget build(BuildContext context) => Container(
      // height: 160,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: NonThemeColor.color71,
            blurRadius: 22,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        // textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'land_info',
                // fontColor: AppColor.blackModern800Light,
                // fontSize: 16,
                // fontWeight: AppFontWeight.bold,
                maxLines: 1,
              ),
              CustomCloseButton(onClose: onClose),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$municipality,  $subMunicipality',
            // fontColor: AppColor.blackModern500Light,
            // fontSize: 12,
            // fontWeight: AppFontWeight.semiBold,
            // height: 1.3,
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Text(
            area ?? '',
            // fontColor: AppColor.blackModern500Light,
            // fontSize: 12,
            // fontWeight: AppFontWeight.semiBold,
            // height: 1.3,
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Text(
            'القطعة: $parcelNo',
            // fontColor: AppColor.blackModern500Light,
            // fontSize: 12,
            // fontWeight: AppFontWeight.semiBold,
            // height: 1.3,
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Text(
            'المرحلة: $stageNo',
            // fontColor: AppColor.blackModern500Light,
            // fontSize: 12,
            // fontWeight: AppFontWeight.semiBold,
            // height: 1.3,
            maxLines: 3,
          ),
        ],
      ),
    );
}
