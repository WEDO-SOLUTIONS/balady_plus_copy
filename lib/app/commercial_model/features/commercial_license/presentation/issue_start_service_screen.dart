import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/not_authorized_indivivisual.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/services/presentation/mvvm/service_data_view_model.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/service_cards_dynamic/service_card_desc_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';

class IssueStartService extends StatefulWidget {
  const IssueStartService({Key? key}) : super(key: key);

  @override
  State<IssueStartService> createState() => _IssueStartServiceState();
}

class _IssueStartServiceState extends State<IssueStartService> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.issueCommercialLicenseOpen);
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.startCardServiceIssueACommercialLicense);
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.CommercialLicense_Open_Service_Card_Event);
  }

  @override
  Widget build(BuildContext context) {
    int? requestId = ModalRoute.of(context)!.settings.arguments as int?;
    return MultiBlocProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext context) => ServiceDataViewModel(
              webService: sl(),
              serviceId: 11010,
            ),
          ),
        ],
        child: Scaffold(
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
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 26),
                    child: ElevatedButtonWidget.startService(
                      onPressed: () async {
                        if (CommonProperties.isLoggedIn) {
                          if (CommonProperties.selectedDelegator != null) {
                            Navigator.of(context).pushNamed(
                              CommercialRouteName.commercialLicensePage,
                              arguments: requestId,
                            );
                          } else {
                            await BottomSheetDialog.showDraggableSheet(
                              context,
                              isFullHeight: false,
                              dialogKeyName:
                                  DialogName.notAuthorizedIndivisualDialog,
                              currentRouteName:
                                  CommercialRouteName.commercialLicenseServicePage,
                              child: NotAuthorizedIndivisualDialog(),
                            );
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (ctx) => NeedLoginDialog(
                              onSuccessLogin: (bool? isSuccess) async {
                                if (isSuccess ?? false) {
                                  if (CommonProperties.selectedDelegator !=
                                      null) {
                                    Navigator.of(context).pushNamed(
                                      CommercialRouteName.commercialLicensePage,
                                      arguments: requestId,
                                    );
                                  } else {
                                    await BottomSheetDialog.showDraggableSheet(
                                      context,
                                      isFullHeight: false,
                                      dialogKeyName: DialogName
                                          .notAuthorizedIndivisualDialog,
                                      currentRouteName: RouteName
                                          .commercialLicenseServicePage,
                                      child: NotAuthorizedIndivisualDialog(),
                                    );
                                  }
                                }
                              },
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

/*
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
            "title": "issue_trade_license",
            "description": "",
            "tag": null,
            "warning": null
          },
          "en": {
            "title": "issue_trade_license",
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
                "description": "issue_service_desc"
              },
              "en": {"title": "Service Description", "description": ""}
            },
            {
              "iconName": IconPath.serviceCardReq,
              "type": ServiceCardsTypes.req,
              "rate": 0,
              "duration": "0",
              "requirements": [
                "issue_service_req1",
                "issue_service_req2",
                "issue_service_req3",
                "issue_service_req4",
                "issue_service_req5"
              ],
              "ar": {"title": "requirements", "description": ""},
              "en": {"title": "requirements", "description": ""}
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
                "descriptionLink": "https://new.balady.gov.sa/ar/node/10856",
                "feesName": "list_municipal_violations",
                "feesLink":
                    "https://balady.gov.sa/sites/default/files/2023-06/%D8%AC%D8%AF%D9%88%D9%84%20%D8%A7%D9%84%D8%AC%D8%B2%D8%A7%D8%A1%D8%A7%D8%AA%20%D8%B9%D9%86%20%D8%A7%D9%84%D9%85%D8%AE%D8%A7%D9%84%D9%81%D8%A7%D8%AA%20%D8%A7%D9%84%D8%A8%D9%84%D8%AF%D9%8A%D8%A9.pdf",
              },
              "en": {"title": "Service Description", "description": ""}
            },
          ]
        },
      );



*/
}
