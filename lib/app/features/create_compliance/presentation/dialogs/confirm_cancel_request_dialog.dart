import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class ConfirmCancelRequestDialog extends StatelessWidget {
  final Function(bool value) onSelect;

  const ConfirmCancelRequestDialog({Key? key, required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.mediumPadding,
          vertical: Constants.semiLargePadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child: CircleIcon(
                      icon: Icons.close,
                      iconColor: AppColor.primary600Light,
                      backgroundColor: AppColor.geyser.withOpacity(0.4),
                      iconSize: 18,
                    )),
              ],
            ),

            const CustomVerticalSpace(height: 16),
            // subtitle
            CustomTextWidget(
              Helpers.translatingWord("compliance_cancel_request_msg".tr()),
              fontColor: AppColor.blackModern900Light,
              fontWeight: AppFontWeight.bold,
              maxLines: 10,
            ),

            const CustomVerticalSpace(height: 40),
            // buttons
            _ConfirmCancelLicenseDialogButtons(
              onCancel: onSelect,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmCancelLicenseDialogButtons extends StatelessWidget {
  final Function? onCancel;

  const _ConfirmCancelLicenseDialogButtons({Key? key, this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EnhancedCustomElevatedButtonWidget(
          btnPressed: () {
            if (onCancel != null) {
              Navigator.of(context).pop();
              onCancel!(true);
            }
          },
          btnColor: Colors.transparent,
          btnBorderColor: Color(0xFFDC2828), // as Scaffold background
          btnBorderWidth: 1.0,
          btnRadius: 8,
          btnText: Helpers.translatingWord('compliance_cancel_request_confirm'),
          btnTextColor: Color(0xFFDC2828),
          btnTextWeight: AppFontWeight.medium,
        ),
        Constants.verticalSpaceSmall,
        EnhancedCustomElevatedButtonWidget(
          btnPressed: () {
            if (onCancel != null) {
              Navigator.of(context).pop();
              onCancel!(false);
            }
          },
          btnText: Helpers.translatingWord("compliance_cancel_request_cancel"),
          btnBorderWidth: 1.0,
          btnRadius: 8,
          btnTextSize: 16.0,
          btnColor: AppColor.primary900Light, // as Scaffold background

          btnTextColor: AppColor.white,
          btnTextWeight: AppFontWeight.medium,
        ),
      ],
    );
  }
}
