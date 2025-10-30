import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../new_appointment/presentation/core/services/view_models/new_appointment_first_step_view_model.dart';
import '../../shared_feature_exports.dart'
    show CustomElevatedIconButtonWidget, CustomSvgIconWidget;

abstract class _ElevatedIconButton extends StatelessWidget {
  final Widget child;
  const _ElevatedIconButton(this.child);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}


class ElevatedIconButtonWidget extends _ElevatedIconButton {
  ///
  ElevatedIconButtonWidget.upload({String? name,NewAppointmentFirstStepViewModel? model ,bool? isMandatory,required VoidCallback onPressed})
      : super(CustomElevatedIconButtonWidget(
          text:  name != null ? isMandatory ==true? "$name  *": name  :"compliance_image_upload".tr(),
          btnColor: Colors.transparent,

          btnBorderColor:model?.isFormValid==false &&isMandatory==true ? AppColor.error:AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.primary800Light,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),

          icon: const CustomSvgIconWidget(IconPath.add, iconSize: 18.0),
          onPressed: onPressed,
        ));

  ElevatedIconButtonWidget.download(
      {required VoidCallback onPressed, String? text, double? height})
      : super(CustomElevatedIconButtonWidget(
          text: text ?? "attachFileButton".tr(),
          btnColor: Colors.transparent,
          btnHeight: height ?? 36,
          btnBorderColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.primary800Light,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          icon:
              const CustomSvgIconWidget(IconPath.receiveSquare, iconSize: 14.0),
          onPressed: onPressed,
        ));

  ElevatedIconButtonWidget.export({required VoidCallback onPressed})
      : super(CustomElevatedIconButtonWidget(
          text: "event_button_text".tr(),
          btnColor: AppColor.primary800Light,
          btnBorderColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          icon: const CustomSvgIconWidget(IconPath.exportW, iconSize: 18.0),
          onPressed: onPressed,
        ));
}
