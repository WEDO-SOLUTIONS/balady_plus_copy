import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show ElevatedButtonWidget;

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';

class CreateComplianceLocationPage extends StatefulWidget {
  const CreateComplianceLocationPage({super.key});

  @override
  State<CreateComplianceLocationPage> createState() => _ServiceCardsPageState();
}

class _ServiceCardsPageState extends State<CreateComplianceLocationPage> {
  int selected = 0;

  @override
  void initState() {
    super.initState();
    CommonFunctions.sendUXCamEvent(
      UXCamEvents.startCardServiceComplianceCertificate,
    );

    CommonFunctions.sendUXCamEvent(
      UXCamEvents.Compliance_Certificate_Open_Service_Card_Event,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('download_certificate'.tr()),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'riyadh_location_question'.tr(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomRadioButtonWidget(
                      label: 'Yes'.tr(),
                      labelStyle: AppStyle.createComplianceRiyadhRadioStyle,
                      radioLabelSpace: 0,
                      onSelected: (p0) {
                        setState(() {
                          selected = p0;
                        });
                      },
                      radioValue: 0,
                      radioGroupValue: selected),
                  const SizedBox(height: 30),
                  CustomRadioButtonWidget(
                    label: 'No'.tr(),
                    labelStyle: AppStyle.createComplianceRiyadhRadioStyle,
                    radioLabelSpace: 0,
                    onSelected: (p0) {
                      setState(() {
                        selected = p0;
                      });
                    },
                    radioValue: 1,
                    radioGroupValue: selected,
                  ),
                ],
              ),
            ),
            ElevatedButtonWidget.next(
              onPressed: () {
                if (selected == 1) {
                  NavigationService.navigatorKey.currentState!.pushNamed(
                    RouteName.submitCompliancePage,
                  );
                } else if (selected == 0) {
                  CommonFunctions.externalLaunch(
                    "https://eservices.alriyadh.gov.sa/Pages/ServicesRedirect.aspx?ServiceCode=2&MainServiceCode=67",
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
