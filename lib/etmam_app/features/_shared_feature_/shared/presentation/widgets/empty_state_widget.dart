import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, IconPath;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomSvgIconWidget, CustomTextWidget, CustomVerticalSpace;
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? img;
  final String? title;
  final String? desc;
  final double imgHeight;
  final bool withMargin;

  const EmptyStateWidget(
      {Key? key,
      this.desc,
      this.img,
      this.title,
      this.withMargin = true,
      this.imgHeight = 162})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: withMargin
          ? const EdgeInsets.symmetric(horizontal: 16)
          : EdgeInsets.zero,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomSvgIconWidget(
                img ?? IconPath.error404,
                // iconWidth: 110,
                iconHeight: imgHeight,
                iconWidth: null,
                iconFit: BoxFit.fitHeight,
              ),
              const CustomVerticalSpace(height: 24),
              CustomTextWidget(
                title ?? "",
                fontSize: 18.0,
                fontColor: AppColor.hunterGreen,
                fontWeight: AppFontWeight.w600,
                textAlign: TextAlign.center,
              ),
              const CustomVerticalSpace(height: 12),
              CustomTextWidget(
                desc ?? "",
                fontSize: 14.0,
                height: 1.6,
                fontColor: AppColor.greyText,
                fontWeight: AppFontWeight.medium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
