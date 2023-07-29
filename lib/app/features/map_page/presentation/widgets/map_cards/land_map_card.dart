import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

import '../../../data/model/excavations.dart';

class DiggingMapCard extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? subSubTitle;

  const DiggingMapCard(
      {super.key, this.subSubTitle, this.subTitle, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
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
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              ImagePath.diggingMapCard,
              width: 60,
              height: 60,
            )),
        CustomHorizontalSpace(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextWidget(
                title ?? "",
                fontColor: AppColor.blackModern800Light,
                fontSize: 16,
                fontWeight: AppFontWeight.bold,
                maxLines: 1,
              ),
              CustomVerticalSpace(height: 8),
              CustomTextWidget(
                subTitle ?? "",
                fontColor: AppColor.blackModern500Light,
                fontSize: 12,
                fontWeight: AppFontWeight.semiBold,
                height: 1.3,
                maxLines: 3,
              ),
              CustomVerticalSpace(height: 8),
              CustomTextWidget(
                subSubTitle ?? "",
                fontColor: Color(0xFFF51C1C),
                fontSize: 12,
                fontWeight: AppFontWeight.semiBold,
                height: 1.3,
                maxLines: 3,
              ),
            ],
          ),
        )
      ]),
    );
  }
}
