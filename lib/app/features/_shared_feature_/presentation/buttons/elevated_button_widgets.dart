import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../shared_feature_exports.dart' show CustomElevatedButtonWidget;

abstract class _ElevatedButton extends StatelessWidget {
  final Widget child;
  const _ElevatedButton(this.child);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class ElevatedButtonWidget extends _ElevatedButton {
  ///
  ElevatedButtonWidget.login({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnMargin: const EdgeInsets.only(top: 12.0),
          text: ("signInButton").tr(),
          btnColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
              color: AppColor.blackModern50Light,
              fontSize: 16,
              fontWeight: FontWeight.bold),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.sendImage({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnMargin: const EdgeInsets.symmetric(horizontal: 40),
          btnColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontSize: 16,
          ),
          btnHeight: 48,
          text: "uploadReport".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.startGame({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.secondary600Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.blackModern50Light,
            fontSize: 12,
          ),
          btnHeight: 40,
          btnWidth: 150,
          text: "startGame".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.allPrayerTimes({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.blackModern50Light,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          btnHeight: 48,
          btnWidth: 150,
          text: "allTimes".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.details({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.blackModern50Light,
            fontSize: 12,
          ),
          btnHeight: 40,
          text: "details".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.apply({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "apply".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.objectionApply({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "objection_apply".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.deletaAll({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: Colors.transparent,
          btnBorderColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.primary800Light,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "clear_all".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.choose({required VoidCallback? onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary800Light,
          btnBorderColor: Colors.transparent,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "choose".tr(),
          onPressed: onPressed,
        ));
  ElevatedButtonWidget.next({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "nextButton".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.applyRequest({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "create_request".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.signIn({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary900Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 48,
          text: "sign_in".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.add({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary900Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "add".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.issuing({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary900Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "cr_make_license_with_current".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.sendRequest({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.white,
          btnBorderColor: AppColor.primary900Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.primary900Light,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "send_request_to_authorities".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.licenseDetails({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: Colors.transparent,
          btnBorderColor: AppColor.white,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "viewLicenseDetails".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.verify(
      {required VoidCallback onPressed, final String? text})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary900Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 48,
          btnWidth: 100,
          text: text ?? "verify".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.startService({required VoidCallback onPressed,bool? isBtnDisabled})
      : super(CustomElevatedButtonWidget(

          btnColor:  isBtnDisabled ==true ? AppColor.black200 :  AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color:  isBtnDisabled == true ? AppColor.black400 :  AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "start_service".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.logout({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: Colors.transparent,
          btnBorderColor: AppColor.vermillion,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.vermillion,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "logout".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.chooseLocation({required VoidCallback? onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary800Light,
          btnBorderColor: Colors.transparent,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "municipalAdvisorLocationButton".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.confirmLocation({
    required VoidCallback? onPressed,
    bool loading = false,
  }) : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary800Light,
          btnBorderColor: Colors.transparent,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "confirmLocation".tr(),
          onPressed: onPressed,
          loading: loading,
        ));

  ElevatedButtonWidget.applyObjection({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.white,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.primary900Light,
            fontSize: 12,
          ),
          btnBorderColor: AppColor.primary900Light,
          btnHeight: 40,
          text: "objection_apply".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.custom(
      {required VoidCallback onPressed, required String text, bool? isDisabled})
      : super(CustomElevatedButtonWidget(
          btnColor: (isDisabled ?? false)
              ? AppColor.black200
              : AppColor.primary900Light,
          btnBorderColor: (isDisabled ?? false)
              ? AppColor.black200
              : AppColor.primary900Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: (isDisabled ?? false) ? AppColor.black400 : AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: text,
          onPressed: (isDisabled ?? false) ? null : onPressed,
        ));

  ElevatedButtonWidget.primaryCustom(
      {required VoidCallback onPressed,
      required String text,
      double? height,
      int? maxLines,
      double? fontSize})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.blackModern50Light,
            fontWeight: FontWeight.w700,
            fontSize: fontSize ?? 16,
          ),
          btnHeight: height ?? 56,
          text: text,
          maxLines: maxLines,
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.primaryCustomBorder(
      {required VoidCallback onPressed,
      required String text,
      double? height,
      double? fontSize,
      int? maxLines,
      Color? color,
      double? width})
      : super(CustomElevatedButtonWidget(
          btnColor: Colors.white,
          btnBorderColor: color ?? AppColor.primary800Light,
          btnWidth: width,
          maxLines: maxLines,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: color ?? AppColor.primary800Light,
            fontWeight: FontWeight.w700,
            fontSize: fontSize ?? 16,
          ),
          btnHeight: height ?? 56,
          text: text,
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.attachFile({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: Colors.transparent,
          btnBorderColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.primary800Light,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "attachFileButton".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.retriveCar({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          text: ("retrieve_request").tr(),
          btnRadius: 6,
          btnHeight: 40,
          btnColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
              color: AppColor.blackModern50Light,
              fontSize: 14,
              fontWeight: FontWeight.bold),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.addBoard({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: Colors.transparent,
          btnBorderColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.primary800Light,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "AddBoard".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.finishButton({
    required VoidCallback? onPressed,
    bool loading = false,
  }) : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary800Light,
          btnBorderColor: Colors.transparent,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: "finishButton".tr(),
          onPressed: onPressed,
          loading: loading,
        ));

  ElevatedButtonWidget.endChat({
    required VoidCallback? onPressed,
  }) : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary800Light,
          btnBorderColor: Colors.transparent,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 52,
          text: "endChat".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.undo({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: Colors.transparent,
          btnBorderColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.primary800Light,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 52,
          text: "undo".tr(),
          onPressed: onPressed,
        ));
  ElevatedButtonWidget.noAdditionalActivities({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: Colors.transparent,
          btnBorderColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.primary800Light,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 52,
          text: "municipalAdvisorNoAdditionalActivities".tr(),
          onPressed: onPressed,
        ));
}
