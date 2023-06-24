import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/dialog_header.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../core/services/view_models/appontment_details_view_model.dart';

class ConfirmCancelAppointmentDialog extends StatelessWidget {
  const ConfirmCancelAppointmentDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Constants.mediumPadding,
        vertical: Constants.semiLargePadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DialogHeader(title: "confirmCancelAppointmentTitleWord".tr()),
          CustomVerticalSpace(
            height: 24,
          ),
          // buttons
          const _ConfirmCancelAppointmentDialogButtons(),
        ],
      ),
    );
  }
}

class _ConfirmCancelAppointmentDialogButtons extends StatelessWidget {
  const _ConfirmCancelAppointmentDialogButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EnhancedCustomElevatedButtonWidget(
          btnPressed: () =>
              locator<AppointmentDetailsViewModel>().cancelAppointment(),
          btnColor: AppColor.primary900Light,
          btnBorderWidth: 2.0,
          btnText: ('confirmCancelAppointmentConfirmButtonWord').tr(),
          btnTextColor: AppColor.white,
          btnRadius: 8,
          btnTextWeight: AppFontWeight.medium,
        ),
        Constants.verticalSpaceSmall,
        EnhancedCustomElevatedButtonWidget(
          btnPressed: () => Navigator.of(context).pop(),
          btnText: ("confirmCancelLicenseCancelButtonWord").tr(),
          btnColor: AppColor.white,
          btnTextColor: AppColor.primary900Light,
          btnBorderColor: AppColor.primary900Light,
          btnTextSize: 16.0,
          btnRadius: 8,
          btnTextWeight: AppFontWeight.medium,
        ),
      ],
    );
  }
}
