import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import '../../data/models/permit_submit_response_model.dart';

class SubmitApplicationSuccessfullyPosters extends StatefulWidget {
  const SubmitApplicationSuccessfullyPosters({Key? key}) : super(key: key);

  @override
  State<SubmitApplicationSuccessfullyPosters> createState() =>
      _SubmitApplicationSuccessfullyPostersState();
}

class _SubmitApplicationSuccessfullyPostersState
    extends State<SubmitApplicationSuccessfullyPosters> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  CommonFunctions.sendEventToAnalytics(
    //     AppEvents.renewCommercialLicenseSuccess);
  }

  @override
  Widget build(BuildContext context) {
    PostersSubmitResponseModel submitResponse = ModalRoute.of(context)!
        .settings
        .arguments as PostersSubmitResponseModel;
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
                        IconPath.submitApplicationSuccessfullyCancel),
                    const SizedBox(height: 16),
                    CustomTextWidget(
                      submitResponse.isGrouped
                          ? 'posters_grouped_request_submit'.tr().replaceAll(
                              "{}", submitResponse.requestId.toString())
                          : 'commercial_request_submit'.tr().replaceAll(
                              "{}", submitResponse.requestId.toString()),
                      textAlign: TextAlign.center,
                      maxLines: 100,
                      height: 1.6,
                      fontColor: AppColor.blackModern800Light,
                      fontSize: 18,
                      fontWeight: AppFontWeight.bold,
                    ),
                    // CustomAutoSizeTextWidget(
                    //   'submit_application_successfully_cancel_message'.tr(),
                    //   textStyle: AppStyle.serviceListTitleTextStyle,
                    //   maxLines: 3,
                    //   textAlign: TextAlign.center,
                    // ),
                    const SizedBox(height: 16),
                    CustomTextWidget(
                      submitResponse.message ?? "",
                      textStyle: AppStyle.serviceListTitleTextStyle,
                      maxLines: 100,
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
