import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
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
          text: ("تسجيل الدخول").tr(),
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
          text:  "uploadReport".tr(),
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

  ElevatedButtonWidget.verify({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: Colors.transparent,
          btnBorderColor: AppColor.primary900Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.primary900Light,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 48,
          text: "verify".tr(),
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.startService({required VoidCallback onPressed})
      : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.white,
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

  ElevatedButtonWidget.custom({
    required VoidCallback onPressed,
    required String text,
  }) : super(CustomElevatedButtonWidget(
          btnColor: Colors.transparent,
          btnBorderColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.primary800Light,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
          text: text,
          onPressed: onPressed,
        ));

  ElevatedButtonWidget.primaryCustom({
    required VoidCallback onPressed,
    required String text,
  }) : super(CustomElevatedButtonWidget(
          btnColor: AppColor.primary800Light,
          textStyle: AppStyle.elevatedButtonStyle.copyWith(
            color: AppColor.blackModern50Light,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          btnHeight: 56,
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
          text: ("طلب إستعادة").tr(),
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
