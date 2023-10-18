import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../core/utils/utils_exports.dart'
    show AppStyle, CommonFunctions, UIHelper;
import '../../shared_feature_exports.dart'
    show CustomElevatedButtonWidget, CustomTextWidget;

class ErrorLoadingComponent extends StatelessWidget {
  final VoidCallback onTryAgain;
  final String? message;
  const ErrorLoadingComponent({
    super.key,
    required this.onTryAgain,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: UIHelper.middlePadding,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error-Message widget
            CustomTextWidget(
              message ?? "errors_server_error_1".tr(),
              textStyle: AppStyle.mainTextStyle,
              textAlign: TextAlign.center,
            ),
            // Space
            UIHelper.verticalMediumSpace,
            // Error-Button widget
            CustomElevatedButtonWidget(
              onPressed: onTryAgain,
              text: "tryAgainButton".tr(),
              btnWidth: 170.0,
              btnHeight: 55.0,
            ),
            // Space
            if (isFailedToken) UIHelper.verticalMediumSpace,
            // Error-Button widget
            if (isFailedToken)
              CustomElevatedButtonWidget(
                onPressed: () => CommonFunctions.signOut(),
                text: "signOutButton".tr(),
                btnWidth: 170.0,
                btnHeight: 55.0,
              ),
          ],
        ),
      ),
    );
  }

  bool get isFailedToken =>
      message?.contains("Failed to generate token") ?? false;
}
