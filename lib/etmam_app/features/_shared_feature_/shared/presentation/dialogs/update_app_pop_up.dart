import 'dart:io';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomPrimaryButton, CustomTextWidget, CustomVerticalSpace;
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, trans;

Future<bool> showUpdateAppPopUpWidget(BuildContext context) async {
  return (await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => UpdateAppPopUp())) ??
      false;
}

class UpdateAppPopUp extends StatelessWidget {
  const UpdateAppPopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CustomTextWidget(
                    trans('update_application'),
                    textAlign: TextAlign.center,
                    fontSize: 18,
                    fontWeight: AppFontWeight.w600,
                  ),
                  const CustomVerticalSpace(height: 24),
                  CustomTextWidget(
                    trans('update_application_desc'),
                    textAlign: TextAlign.center,
                    fontSize: 12,
                    fontWeight: AppFontWeight.regular,
                  ),
                  const CustomVerticalSpace(height: 32),
                  CustomPrimaryButton(
                    onPressed: () {
                      //  Navigator.pop(context);

                      if (Platform.isAndroid) {
                        LaunchReview.launch(
                            androidAppId: "momra.etmam.android",
                            iOSAppId: "6443525432");
                      } else {
                        LaunchReview.launch(
                            writeReview: false, iOSAppId: "6443525432");
                      }
                    },
                    btnText: trans('update_application_button'),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
