import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/payment_widget.dart';
import '../../../commercial_license_cancel/data/models/submit_response.dart';
import '../../../commercial_license_cancel/presentation/submit_application_successfully_cancel/mvvm/submit_rating_view_model.dart';
import '../../data/models/permit_submit_response_model.dart';

class SubmitApplicationSuccessfullyTobacco extends StatefulWidget {
  const SubmitApplicationSuccessfullyTobacco({Key? key}) : super(key: key);

  @override
  State<SubmitApplicationSuccessfullyTobacco> createState() =>
      _SubmitApplicationSuccessfullyTobaccoState();
}

class _SubmitApplicationSuccessfullyTobaccoState
    extends State<SubmitApplicationSuccessfullyTobacco> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(UXCamEvents.finishServiceTobaccoPermit);
  }

  @override
  Widget build(BuildContext context) {
    PermitTobaccoSubmitResponseModel submitResponse = ModalRoute.of(context)!
        .settings
        .arguments as PermitTobaccoSubmitResponseModel;
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
                      'commercial_request_submit'.tr().replaceAll(
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
                    if (submitResponse.requestId != null)
                      CustomTextButtonWidget(
                        text: 'service_evaluation'.tr(),
                        onPressed: () {
                          Navigator.of(context).popAndPushNamed(
                            CommercialRouteName.submitRatingCancelScreen,
                            arguments: SubmitRatingViewModel(
                              showDetails: false,
                              webService: sl(),
                              submitResponse: SubmitResponse(
                                requestId: submitResponse.requestId!,
                                payUrl: submitResponse.payUrl,
                                crNumber: CommonProperties
                                        .selectedDelegator?.crNumber ??
                                    "",
                                crType: CommonProperties
                                        .selectedDelegator?.crType ??
                                    "",
                              ),
                            ),
                          );
                        },
                        haveUnderline: true,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              submitResponse.billNumber != null &&
                      submitResponse.billNumber!.isNotEmpty
                  ? PaymentWidget(
                      requestKey: submitResponse.billKey ?? "",
                      billNumber: submitResponse.billNumber!,
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
