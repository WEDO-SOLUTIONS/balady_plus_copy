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

class NoDataWidget extends StatelessWidget {
  final double widgetHeight;
  final String? title;

  const NoDataWidget({Key? key, this.widgetHeight = 80, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widgetHeight,
      width: double.infinity,
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
            title ?? trans("no_available_services"),
            fontSize: 14,
            fontColor: AppColor.bottomNavigationShadow,
            fontWeight: AppFontWeight.regular,
            textAlign: TextAlign.center,
          ),
          CustomVerticalSpace(height: 16),
        ],
      ),
    );
  }
}
