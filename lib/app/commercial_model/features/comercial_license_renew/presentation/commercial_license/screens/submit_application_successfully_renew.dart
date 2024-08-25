import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/data/models/submit_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/submit_application_successfully_cancel/mvvm/submit_rating_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import '../../../../commercial_license/data/models/cr_submit_response_model.dart';

class SubmitApplicationSuccessfullyRenew extends StatefulWidget {
  const SubmitApplicationSuccessfullyRenew({Key? key}) : super(key: key);

  @override
  State<SubmitApplicationSuccessfullyRenew> createState() =>
      _SubmitApplicationSuccessfullyRenewState();
}

class _SubmitApplicationSuccessfullyRenewState
    extends State<SubmitApplicationSuccessfullyRenew> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendEventToAnalytics(
        AppEvents.renewCommercialLicenseSuccess);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.finishServiceRenewLicenseService);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.RenewCommercialLicense_Open_Success_Page_Event);
  }

  @override
  Widget build(BuildContext context) {
    (
      String from,
      CrSubmitResponseModel submitResponse,
      double? totalCost,
    ) arguments = ModalRoute.of(context)!.settings.arguments as (
      String from,
      CrSubmitResponseModel submitResponse,
      double? totalCost,
    );
    CrSubmitResponseModel submitResponse = arguments.$2;
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
                    CustomAutoSizeTextWidget(
                      'vd_request_submit'.tr(),
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
                      '${'application_no_has_been_submitted'.tr()} ${submitResponse.requestId} ${(submitResponse.payUrl?.isNotEmpty ?? false) ? '${'and_issue_invoice_service_amount'.tr()} ${arguments.$3} ${'sar'.tr()}' : 'application_no_has_been_submitted_two'.tr()}',
                      textStyle: AppStyle.serviceListTitleTextStyle,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    CustomTextButtonWidget(
                      text: 'service_evaluation'.tr(),
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed(
                          CommercialRouteName.submitRatingCancelScreen,
                          arguments: SubmitRatingViewModel(
                            webService: sl(),
                            submitResponse: SubmitResponse(
                                payUrl: submitResponse.payUrl,
                                crNumber: CommonProperties
                                        .selectedDelegator?.crNumber ??
                                    "",
                                crType: CommonProperties
                                        .selectedDelegator?.crType ??
                                    "",
                                requestId: submitResponse.requestId!),
                          ),
                        );
                      },
                      haveUnderline: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              submitResponse.payUrl != null
                  ? ElevatedButtonWidget.primaryCustomBorder(
                      text: 'viewـinvoice'.tr(),
                      onPressed: () async {
                        Navigator.of(context).popAndPushNamed(
                          CommercialRouteName.invoiceDetails,
                          arguments: {
                            "payUrl": submitResponse.payUrl.toString(),
                            "xSourceApp": "SADAD",
                          },
                        );
                      },
                    )
                  : const SizedBox(),
              const SizedBox(height: 16),
              ElevatedButtonWidget.primaryCustom(
                text: arguments.$1 == "licenses"
                    ? "back_licenses_page".tr()
                    : "back_request_page".tr(),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
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
