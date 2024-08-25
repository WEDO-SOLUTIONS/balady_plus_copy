import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SubmitDisclosedSuccessfullyScreen extends StatefulWidget {
  const SubmitDisclosedSuccessfullyScreen({Key? key}) : super(key: key);

  @override
  State<SubmitDisclosedSuccessfullyScreen> createState() =>
      _SubmitDisclosedSuccessfullyScreenState();
}

class _SubmitDisclosedSuccessfullyScreenState
    extends State<SubmitDisclosedSuccessfullyScreen> {
  @override
  void initState() {
    super.initState();

    CommonFunctions.sendUXCamEvent(
      UXCamEvents.openConfirmTobaccoDisclosedScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    // String requestId = ModalRoute.of(context)!.settings.arguments as String;
    // SubmitResponse submitResponse = arguments.$2;
    return WillPopScope(
      onWillPop: () async {
        return Future<bool>.value(false);
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      IconPath.submitApplicationSuccessfullyCancel,
                    ),
                    const SizedBox(height: 16),
                    CustomAutoSizeTextWidget(
                      'disclosure_completed_successfully'.tr(),
                      textStyle: AppStyle.sectionTitleStyle,
                    ),
                    // CustomAutoSizeTextWidget(
                    //   'submit_application_successfully_cancel_message'.tr(),
                    //   textStyle: AppStyle.serviceListTitleTextStyle,
                    //   maxLines: 3,
                    //   textAlign: TextAlign.center,
                    // ),
                    const SizedBox(height: 16),
                    CustomAutoSizeTextWidget(
                      'disclosure_completed_successfully_message'.tr(),
                      textStyle: AppStyle.serviceListTitleTextStyle,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // CustomTextButtonWidget(
                    //   text: 'service_evaluation'.tr(),
                    //   onPressed: () {
                    //     // Navigator.of(context).popAndPushNamed(
                    //     //   CommercialRouteName.submitRatingCancelScreen,
                    //     //   arguments: SubmitRatingViewModel(
                    //     //     webService: sl(),
                    //     //     requestId: requestId,
                    //     //   ),
                    //     // );
                    //   },
                    //   haveUnderline: true,
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButtonWidget.primaryCustomBorder(
                text: 'back_invoices'.tr(),
                onPressed: () {
                  Navigator.of(context).popAndPushNamed(CommercialRouteName.invoices);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButtonWidget.primaryCustom(
                text: "return_home_page".tr(),
                onPressed: () {
                  Helpers.backNavigationToHomeScreen();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
