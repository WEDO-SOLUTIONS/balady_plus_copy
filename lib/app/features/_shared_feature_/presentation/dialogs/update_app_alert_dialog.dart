import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart';
import '../../shared_feature_exports.dart';

class UpdateAppAlertDialog extends StatelessWidget {
  const UpdateAppAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      backgroundColor: AppColor.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomSvgIconWidget(
            IconPath.mobile,
            iconSize: 86,
          ),
          const SizedBox(height: 24),
          CustomTextWidget(
            "new_update".tr(),
            fontSize: 20,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.blackModern600Light,
          ),
          const SizedBox(height: 8),
           CustomTextWidget(
            'update_desc'.tr(),
            fontSize: 18,
            maxLines: null,
            textAlign: TextAlign.center,
            height: 1.2,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.blackModern500Light,
          ),
          const SizedBox(height: 24),
          CustomElevatedButtonWidget(
            btnColor: AppColor.primary900Light,
            textStyle: AppStyle.elevatedButtonStyle.copyWith(
              color: AppColor.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
            btnHeight: 52,
            btnWidth: MediaQuery.sizeOf(context).width,
            text: "force_update_app".tr(),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
