import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/data/models/submit_response.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/submit_application_successfully_cancel/mvvm/submit_rating_view_model.dart';
import 'package:balady_plus/app/features/profile_features/invoices/data/models/invoices_model.dart';
import 'package:balady_plus/app/features/profile_features/invoices/domain/entities/invoice_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../commercial_license/data/models/cr_submit_response_model.dart';

class SubmitApplicationSuccessfullyRenew extends StatelessWidget {
  const SubmitApplicationSuccessfullyRenew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    (
      String from,
      CrSubmitResponseModel submitResponse,
      double totalCost,
    ) arguments = ModalRoute.of(context)!.settings.arguments as (
      String from,
      CrSubmitResponseModel submitResponse,
      double totalCost,
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
                          RouteName.submitRatingCancelScreen,
                          arguments: SubmitRatingViewModel(
                            webService: sl(),
                            submitResponse: submitResponse,
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
                      text: 'دفع الفاتورة'.tr(),
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
