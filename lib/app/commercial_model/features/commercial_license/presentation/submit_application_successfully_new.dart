import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import '../domain/entities/cr_submit_response.dart';

class SubmitApplicationSuccessfullyNew extends StatefulWidget {
  const SubmitApplicationSuccessfullyNew({Key? key}) : super(key: key);

  @override
  State<SubmitApplicationSuccessfullyNew> createState() =>
      _SubmitApplicationSuccessfullyNewState();
}

class _SubmitApplicationSuccessfullyNewState
    extends State<SubmitApplicationSuccessfullyNew> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendEventToAnalytics(
        AppEvents.issueCommercialLicenseSuccess);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.finishServiceIssueACommercialLicense);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.CommercialLicense_Open_Success_Page_Event);
  }

  @override
  Widget build(BuildContext context) {
    (String from, CrSubmitResponse submitResponse, double totalCost, ) arguments = ModalRoute.of(context)!.settings.arguments as (String from, CrSubmitResponse submitResponse, double totalCost,);
    CrSubmitResponse submitResponse = arguments.$2;
    return WillPopScope(
      onWillPop: () async {
        return Future<bool>.value(false);
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.only(
                        top: MediaQuery.of(context).padding.top + 10,
                        start: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        IconPath.qrWhiteCloseIcon,
                        height: 20.0,
                        width: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                        IconPath.submitApplicationSuccessfullyCancel),
                    const SizedBox(height: 32),
                    CustomAutoSizeTextWidget(
                      'commercial_request_submit'.tr().replaceAll(
                          "{}", submitResponse.requestId.toString()),
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
                      submitResponse.message ?? "",
                      textStyle: AppStyle.serviceListTitleTextStyle,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    /* CustomTextButtonWidget(
                      text: 'service_evaluation'.tr(),
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed(
                          CommercialRouteName.submitRatingCancelScreen,
                          arguments: SubmitRatingViewModel(
                            webService: sl(),
                            submitResponse: SubmitResponse(
                              requestId: submitResponse.requestId!,
                              payUrl: submitResponse.payUrl,
                              crNumber: CommonProperties
                                      .selectedDelegator?.crNumber ??
                                  "",
                              crType:
                                  CommonProperties.selectedDelegator?.crType ??
                                      "",
                            ),
                          ),
                        );
                      },
                      haveUnderline: true,
                    ),*/
                  ],
                ),
              ),
              const SizedBox(height: 16),
              submitResponse.payUrl != null
                  ? ElevatedButtonWidget.primaryCustomBorder(
                      text: "pay_bill".tr(),
                      onPressed: () async {
                        CommonFunctions.openBaladyWebView(
                            submitResponse.payUrl);
                      },
                    )
                  : const SizedBox(),
              const SizedBox(height: 16),
              ElevatedButtonWidget.primaryCustom(
                text: ('go_to_home').tr(),
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
