import 'package:balady_plus/app/core/utils/enums/message_types.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import 'custom_alert_dialog_widget.dart';

class CustomPopUpsWidgets {
  static Future<bool> showLoadingDialog(BuildContext context, {Color loadingColor = AppColor.primary900Light}) async =>
      (await showGeneralDialog<bool>(
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionBuilder: (_, a1, a2, widget) {
          return PopScope(
            canPop: false,
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(loadingColor)),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
      )) ??
      false;

  static Future<bool> showCloseAppMessageDialog(
    BuildContext context, {
    VoidCallback? primaryBtn,
    VoidCallback? secondaryBtn,
  }) async =>
      (await showGeneralDialog<bool>(
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionBuilder: (_, a1, a2, widget) {
          return PopScope(
            canPop: false,
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: CustomAlertDialogWidget(
                  contentText: ("popUpCloseAppMessageWord").tr(),
                  primaryBtnPressed: primaryBtn ?? () => Navigator.of(context).pop(true),
                  primaryBtnText: ("popUpCloseAppConfirmButtonWord").tr(),
                  secondaryBtnPressed: secondaryBtn ?? () => Navigator.of(context).pop(false),
                  secondaryBtnText: ("popUpCloseAppDeclineButtonWord").tr(),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
      )) ??
      false;

  static Future<bool> showConfirmAppMessageDialog(
    BuildContext context,
    String text, {
    VoidCallback? primaryBtn,
    VoidCallback? secondaryBtn,
  }) async =>
      (await showGeneralDialog<bool>(
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionBuilder: (_, a1, a2, widget) {
          return PopScope(
            canPop: false,
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: CustomAlertDialogWidget(
                  titleMessageType: MessageType.confirm,
                  contentText: text,
                  primaryBtnPressed: primaryBtn ?? () => Navigator.of(context).pop(true),
                  primaryBtnText: ("yes").tr(),
                  secondaryBtnPressed: secondaryBtn ?? () => Navigator.of(context).pop(false),
                  secondaryBtnText: ("no").tr(),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
      )) ??
      false;

  static Future<bool> showConfirmMessageDialog(
    BuildContext context,
    String text, {
    VoidCallback? primaryBtn,
    VoidCallback? secondaryBtn,
  }) async =>
      (await showGeneralDialog<bool>(
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionBuilder: (_, a1, a2, widget) {
          return PopScope(
            canPop: false,
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: CustomAlertDialogWidget(
                  titleMessageType: MessageType.none,
                  contentText: text,
                  primaryBtnPressed: primaryBtn ?? () => Navigator.of(context).pop(true),
                  primaryBtnText: ("confirm").tr(),
                  secondaryBtnPressed: secondaryBtn ?? () => Navigator.of(context).pop(false),
                  secondaryBtnText: ("cancel").tr(),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
      )) ??
      false;

  static Future<bool> showSuccessMessageDialog(BuildContext context, String successText) async =>
      (await showGeneralDialog<bool>(
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionBuilder: (_, a1, a2, widget) {
          return PopScope(
            canPop: false,
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: CustomAlertDialogWidget(titleMessageType: MessageType.success, contentText: successText),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
      )) ??
      false;

  static Future<bool> showWarningMessageDialog(BuildContext context, String warningText) async =>
      (await showGeneralDialog<bool>(
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionBuilder: (_, a1, a2, widget) {
          return PopScope(
            canPop: false,
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: CustomAlertDialogWidget(titleMessageType: MessageType.warning, contentText: warningText),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
      )) ??
      false;

  static Future<bool> showErrorMessageDialog(BuildContext context, String errorText) async =>
      (await showGeneralDialog<bool>(
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionBuilder: (_, a1, a2, widget) {
          return PopScope(
            canPop: false,
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: CustomAlertDialogWidget(titleMessageType: MessageType.error, contentText: errorText),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
      )) ??
      false;

  static Future<bool> showHTMLErrorMessageDialog(BuildContext context, String errorText, bool isHtml) async =>
      (await showGeneralDialog<bool>(
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionBuilder: (_, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: CustomHTMLAlertDialogWidget(
                titleMessageType: MessageType.error,
                contentText: errorText,
                isHtml: isHtml,
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 100),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
      )) ??
      false;

  // static Future<dynamic> showBottomSheetWithBlock(
  //     BuildContext context, RequestOwnershipTransferDetailsCubit? bloc,
  //     {required Widget child,
  //     bool isFullHeight = true,
  //     double? height,
  //     double? radius}) async {
  //   final screenHeight = MediaQuery.of(context).size.height;
  //   final screenStatusBarHeight = MediaQuery.of(context).padding.top + 5;
  //   return (showModalBottomSheet(
  //         context: context,
  //         isDismissible: true,
  //         isScrollControlled: true,
  //         enableDrag: false,
  //         shape: RoundedRectangleBorder(
  //           borderRadius:
  //               BorderRadius.vertical(top: Radius.circular(radius ?? 10)),
  //         ),
  //         builder: (context) => SizedBox(
  //           // height: height ?? screenHeight * 0.90, // 90% from screenHeight
  //           height: isFullHeight
  //               ? height ?? screenHeight - screenStatusBarHeight
  //               : null,
  //           child: BlocProvider.value(value: bloc!, child: child),
  //         ),
  //       )) ??
  //       false;
  // }

  static Future<dynamic> showBottomSheet(
    BuildContext context, {
    required Widget child,
    bool isFullHeight = true,
    double? height,
    double? radius,
  }) async {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenStatusBarHeight = MediaQuery.of(context).padding.top + 5;
    return (showModalBottomSheet(
          context: context,
          isDismissible: true,
          isScrollControlled: true,
          enableDrag: false,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(radius ?? 10))),
          builder: (context) => SizedBox(
            // height: height ?? screenHeight * 0.90, // 90% from screenHeight
            height: isFullHeight ? height ?? screenHeight - screenStatusBarHeight : null,
            child: child,
          ),
        )) ??
        false;
  }
}
