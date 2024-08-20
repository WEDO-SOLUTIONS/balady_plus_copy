import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';

import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';

import 'package:balady_plus/app/features/services/services_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:balady_plus/app/features/services/presentation/mvvm/service_data_view_model.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/service_cards_dynamic/service_card_desc_widget.dart';
import '../blocs/renew_start_service_bloc/renew_commercial_license_bloc.dart';

class RenewStartService extends StatefulWidget {
  const RenewStartService({Key? key}) : super(key: key);

  @override
  State<RenewStartService> createState() => _RenewStartServiceState();
}

class _RenewStartServiceState extends State<RenewStartService> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.renewCommercialLicenseOpen);
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.startCardServiceRenewLicenseService);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.RenewCommercialLicense_Open_Service_Card_Event);
  }

  @override
  Widget build(BuildContext context) {
    int licenseId = ModalRoute.of(context)!.settings.arguments as int;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              RenewStartServiceBloc(licenseId: licenseId),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ServiceDataViewModel(
            webService: sl(),
            serviceId: 10485,
          ),
        ),
      ],
      child: BlocConsumer<RenewStartServiceBloc, RenewStartServiceState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    const Expanded(child: ServiceCardDescDynamicWidget()),
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(36),
                            topRight: Radius.circular(36),
                          ),
                          color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 26),
                      child: state.status == BlocStatus.loading
                          ? const Center(child: CustomCircularLoadingWidget())
                          : ElevatedButtonWidget.startService(
                              onPressed: () async {
                                context
                                    .read<RenewStartServiceBloc>()
                                    .add(const ValidateBeforeApplyEvent());
                              },
                            ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  ServiceModel model() => ServiceModel.fromJson(
        {
          "id": 1,
          "icon": "send_image",
          "3d_icon": null,
          "order": 1,
          "isNew": false,
          "isImportant": false,
          "action": {"type": "cards", "value": ""},
          "ar": {
            "title": "renew_service_name",
            "description": "",
            "tag": null,
            "warning": ""
          },
          "en": {
            "title": "renew_service_name",
            "description": "",
            "tag": null,
            "warning": null
          },
          "cards": [
            {
              "iconName": IconPath.serviceCardDesc,
              "type": ServiceCardsTypes.desc,
              "rate": 0,
              "duration": "duration_10_days",
              "fees": -1,
              "feesName": "calculator_fees",
              "feesLink": "https://apps.balady.gov.sa/Eservices/FeesCalculator",
              "ar": {
                "title": "service_desc",
                "description": "renew_service_desc"
              },
              "en": {"title": "Service Description", "description": ""}
            },
            {
              "iconName": IconPath.serviceCardReq,
              "type": ServiceCardsTypes.req,
              "rate": 0,
              "duration": "0",
              "requirements": ["renew_service_req1", "renew_service_req2"],
              "ar": {"title": "requirements", "description": ""},
              "en": {"title": "requirements", "description": ""}
            },
            {
              "iconName": IconPath.serviceCardFlow,
              "type": ServiceCardsTypes.flow,
              "rate": 0,
              "duration": "0",
              "flow": [
                {
                  "title": "",
                  "steps": [
                    "rewnew_service_applying_step_1",
                    "rewnew_service_applying_step_2",
                  ]
                },
              ],
              "ar": {"title": "applying_steps", "description": ""},
              "en": {"title": "", "description": ""}
            },
            {
              "iconName": IconPath.warning2,
              "type": ServiceCardsTypes.authorInfo,
              "rate": 0,
              "duration": "",
              "fees": null,
              "ar": {
                "title": "conditions_and_fines",
                "description": "service_conditions_and_fess",
                "descriptionLink": "https://new.balady.gov.sa/ar/node/10855",
                "feesName": "list_municipal_violations",
                "feesLink":
                    "https://balady.gov.sa/sites/default/files/2023-06/%D8%AC%D8%AF%D9%88%D9%84%20%D8%A7%D9%84%D8%AC%D8%B2%D8%A7%D8%A1%D8%A7%D8%AA%20%D8%B9%D9%86%20%D8%A7%D9%84%D9%85%D8%AE%D8%A7%D9%84%D9%81%D8%A7%D8%AA%20%D8%A7%D9%84%D8%A8%D9%84%D8%AF%D9%8A%D8%A9.pdf",
              },
              "en": {"title": "Service Description", "description": ""}
            },
          ]
        },
      );
}
