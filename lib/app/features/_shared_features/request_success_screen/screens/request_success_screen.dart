import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SubmitApplicationSuccessfullyCancel extends StatelessWidget {
  final String? textFirstButton;
  final VoidCallback? onPressedFirstButton;
  final String textScendButton;
  final VoidCallback onPressedScendButton;

  const SubmitApplicationSuccessfullyCancel({
    super.key,
    this.textFirstButton,
    this.onPressedFirstButton,
    required this.textScendButton,
    required this.onPressedScendButton,
  });

  //   @override
  //   State<SubmitApplicationSuccessfullyCancel> createState() =>
  //       _SubmitApplicationSuccessfullyCancelState();
  // }
  //
  // class _SubmitApplicationSuccessfullyCancelState
  //     extends State<SubmitApplicationSuccessfullyCancel> {
  //   @override
  //   void initState() {
  //     // TODO: implement initState
  //     super.initState();
  //     CommonFunctions.sendEventToAnalytics(AppEvents.cancelCommercialLicenseOpen);
  //     CommonFunctions.sendAnalyticsEvent(
  //       AnalyticsEvents.finishServiceCancelLicenseService,
  //     );
  //   }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    return PopScope(
      canPop: false,
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
                    SvgPicture.asset(IconPath.submitApplicationSuccessfullyCancel),
                    const SizedBox(height: 16),
                    CustomAutoSizeTextWidget('vd_request_submit'.tr(), textStyle: AppStyle.sectionTitleStyle),
                    const SizedBox(height: 16),
                    CustomAutoSizeTextWidget(
                      '${'application_no_has_been_submitted'.tr()} ${arguments['requestId']} ${(arguments['payUrl']?.isNotEmpty ?? false) ? '${'and_issue_invoice_service_amount'.tr()} ${arguments['']} ${'sar'.tr()}' : 'application_no_has_been_submitted_two'.tr()}',
                      textStyle: AppStyle.serviceListTitleTextStyle,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    CustomTextButtonWidget(text: 'service_evaluation'.tr(), onPressed: () {}, haveUnderline: true),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              onPressedFirstButton != null
                  ? ElevatedButtonWidget.primaryCustomBorder(
                      text: textFirstButton ?? '',
                      onPressed: onPressedFirstButton!,
                    )
                  : const SizedBox(),
              const SizedBox(height: 16),
              ElevatedButtonWidget.primaryCustom(text: textScendButton, onPressed: onPressedScendButton),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
