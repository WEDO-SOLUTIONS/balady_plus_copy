import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/dialog_header.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../core/services/view_models/appontment_details_view_model.dart';
import 'package:collection/collection.dart';

class ConfirmCancelAppointmentDialog extends StatefulWidget {
  const ConfirmCancelAppointmentDialog({Key? key}) : super(key: key);

  @override
  State<ConfirmCancelAppointmentDialog> createState() =>
      _ConfirmCancelAppointmentDialogState();
}

class _ConfirmCancelAppointmentDialogState
    extends State<ConfirmCancelAppointmentDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Container(
          color: AppColor.white,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Constants.mediumPadding,
              vertical: Constants.semiLargePadding,
            ),
            child: SingleChildScrollView(
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
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmCancelAppointmentDialogButtons extends StatefulWidget {
  const _ConfirmCancelAppointmentDialogButtons({Key? key}) : super(key: key);

  @override
  State<_ConfirmCancelAppointmentDialogButtons> createState() =>
      _ConfirmCancelAppointmentDialogButtonsState();
}

class _ConfirmCancelAppointmentDialogButtonsState
    extends State<_ConfirmCancelAppointmentDialogButtons> {
  bool isFormValid = false;
  @override
  Widget build(BuildContext context) {
    final model = locator<AppointmentDetailsViewModel>();
    return Column(
      children: [
        CustomVerticalSpace(height: 16),
        CustomTapWidgetForLongDialog(
          items: model.cancelList,
          value: model.selectedCancelReason,
          onChangeType: (DropDownItem? item) {
            model.selectedCancelReason = item;
            LookUpItem? i = model.cancelReasonsList?.data?.result
                ?.firstWhereOrNull(
                    (element) => element.id.toString() == item?.id);
            model.selectedCancelReasonItem = i;
            isFormValid = true;

            if (model.selectedCancelReasonItem?.isOther == true &&
                (model.cancelReason?.isEmpty ?? true)) isFormValid = false;
            setState(() {});
          },
          label: ("appointments_cancel_reasons_title").tr(),
          hint: ("appointments_cancel_reasons_title").tr(),
          searchHint: ("searchFor").tr(),
        ),
        //  CustomVerticalSpace(height: 8),
        if (model.selectedCancelReasonItem?.isOther == true)
          CustomTextFieldWidget(
            label: ("appointments_cancel_reasons_text").tr(),
            hintText: ("appointments_cancel_reasons_text").tr(),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            initialValue: model.cancelReason,
            fillColor: Colors.transparent,
            onSubmitted: (_) {},
            onValidate: (text) {
              if (text.toString().isEmpty) {
                return ('text_field_error').tr();
              }
              return null;
            },
            onChanged: (text) {
              isFormValid = true;
              model.cancelReason = text;

              if (model.selectedCancelReasonItem?.isOther == true &&
                  (model.cancelReason?.isEmpty ?? true)) isFormValid = false;

              setState(() {});
            },
          ),
        CustomVerticalSpace(height: 32),
        EnhancedCustomElevatedButtonWidget(
          btnPressed: isFormValid
              ? () => locator<AppointmentDetailsViewModel>().cancelAppointment()
              : null,
          btnColor: isFormValid ? AppColor.primary900Light : AppColor.black200,
          btnTextColor: isFormValid ? AppColor.white : AppColor.black400,
          btnBorderWidth: 2.0,
          btnText: ('confirmCancelAppointmentConfirmButtonWord').tr(),
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
