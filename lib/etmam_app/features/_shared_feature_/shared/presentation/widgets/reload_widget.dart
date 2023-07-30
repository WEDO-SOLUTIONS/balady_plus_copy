import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomIconButtonWidget,
        CustomSvgIconWidget,
        CustomTextWidget,
        CustomVerticalSpace;
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, AppFontWeight, IconPath, trans;

class ReloadWidget extends StatelessWidget {
  final double widgetHeight;
  final VoidCallback onTab;

  const ReloadWidget({Key? key, this.widgetHeight = 150, required this.onTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widgetHeight,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor.white,
        boxShadow: const [
          BoxShadow(
              color: Color(0x14d1d5db),
              offset: Offset(-2, 4),
              blurRadius: 8,
              spreadRadius: 0)
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextWidget(
            trans('data_not_retrieved'),
            fontSize: 14,
            fontColor: AppColor.bottomNavigationShadow,
            fontWeight: AppFontWeight.regular,
            textAlign: TextAlign.center,
          ),
          CustomVerticalSpace(height: 16),
          CustomIconButtonWidget(
            padding: EdgeInsets.zero,
            btnPressed: onTab,
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSvgIconWidget(
                  IconPath.reloadIcon,
                  iconHeight: 18,
                  iconWidth: 17,
                  iconColor: AppColor.spruce,
                ),
                const CustomHorizontalSpace(width: 8),
                CustomTextWidget(
                  trans('reload'),
                  fontSize: 16,
                  fontColor: AppColor.spruce,
                  fontWeight: AppFontWeight.medium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
