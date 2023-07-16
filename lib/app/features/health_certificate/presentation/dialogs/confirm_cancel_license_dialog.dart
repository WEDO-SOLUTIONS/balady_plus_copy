import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class ConfirmCancelLicenseDialog extends StatelessWidget {
  final Function? onCancel;

  const ConfirmCancelLicenseDialog({Key? key, this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.mediumPadding,
        vertical: Constants.semiLargePadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // title
          CustomTextWidget(
            Helpers.translatingWord("confirmCancelLicenseTitleWord"),
            fontColor: AppColor.black,
            fontSize: 18.0,
          ),
          const CustomVerticalSpace(height: 40),
          // subtitle
          CustomTextWidget(
            Helpers.translatingWord("confirmCancelLicenseSubtitleWord"),
            fontColor: AppColor.warmGrey2,
            fontWeight: AppFontWeight.medium,
          ),
          const CustomVerticalSpace(height: 40),
          // buttons
          _ConfirmCancelLicenseDialogButtons(
            onCancel: onCancel,
          ),
        ],
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
              onCancel!();
            }
          },
          btnColor: AppColor.darkTurquoise, // as Scaffold background
          btnBorderWidth: 2.0,
          btnText:
              Helpers.translatingWord('confirmCancelLicenseConfirmButtonWord'),
          btnTextColor: AppColor.white,
          btnTextWeight: AppFontWeight.medium,
        ),
        Constants.verticalSpaceSmall,
        CustomTextButtonWidget(
          onPressed: () => Navigator.of(context).pop(),
          text: Helpers.translatingWord("confirmCancelLicenseCancelButtonWord"),
          btnTextColor: AppColor.darkTurquoise,
          btnTextSize: 16.0,
          btnTextWeight: AppFontWeight.medium,
        ),
      ],
    );
  }
}
