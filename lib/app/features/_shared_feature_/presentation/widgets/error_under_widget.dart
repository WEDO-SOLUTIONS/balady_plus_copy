import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, UIHelper;
import '../../shared_feature_exports.dart' show CustomTextWidget;

class ErrorUnderWidget extends StatelessWidget {
  final String? errorText;
  const ErrorUnderWidget({super.key, required this.errorText});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: UIHelper.duration,
      child: showError
          ? Padding(
              padding: padding,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: CustomTextWidget(
                  errorText!,
                  textStyle: AppStyle.mainTextSecondaryStyle.copyWith(
                    color: AppColor.error,
                    fontSize: 14.0,
                  ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  bool get showError => errorText != null && errorText!.isNotEmpty;

  EdgeInsetsGeometry get padding =>
      const EdgeInsets.only(bottom: UIHelper.middlePadding, top: 6.0);
}
