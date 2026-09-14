import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/utils_exports.dart' show UIHelper;
import '../../shared_feature_exports.dart' show CustomElevatedButtonWidget, CustomTextWidget;

class ErrorLoadingComponent extends StatelessWidget {
  final VoidCallback onTryAgain;
  final String? message;
  const ErrorLoadingComponent({super.key, required this.onTryAgain, this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIHelper.middlePadding),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error-Message widget
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextWidget(
                message ?? "errors_server_error_1".tr(),
                fontColor: AppColor.blackModern900Light,
                fontSize: 14,
                maxLines: null,
                height: 1.5,
                textAlign: TextAlign.center,
              ),
            ),
            // Space
            UIHelper.verticalMediumSpace,
            // Error-Button widget
            CustomElevatedButtonWidget(
              onPressed: onTryAgain,
              btnColor: AppColor.primary900Light,
              text: "tryAgainButton".tr(),
              btnWidth: 170.0,
              btnHeight: 55.0,
            ),
          ],
        ),
      ),
    );
  }
}
