import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, IconPath, trans;
import 'package:flutter/material.dart';

import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomSvgIconWidget, CustomTextWidget, CustomVerticalSpace;

class OtpHeaderWidget extends StatelessWidget {
  const OtpHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomSvgIconWidget(
          IconPath.baladyOtpLogo,
          iconHeight: 60,
          iconWidth: 60,
        ),
        const CustomVerticalSpace(height: 25),
        CustomTextWidget(trans("otp_code"),
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.black,
            fontSize: 22),
        const CustomVerticalSpace(height: 20),
        CustomTextWidget(
          trans("otp_code_desc"),
          fontColor: AppColor.bottomNavigationShadow,
          fontWeight: AppFontWeight.regular,
          fontSize: 14,
          textAlign: TextAlign.center,
        ),
        const CustomVerticalSpace(height: 20),
        CustomTextWidget(
          trans("lbl_enter_verify_code"),
          fontColor: AppColor.baladyDarkGreen2,
          fontSize: 13,
        ),
        //const CustomVerticalSpace(height: 64),
      ],
    );
  }
}
