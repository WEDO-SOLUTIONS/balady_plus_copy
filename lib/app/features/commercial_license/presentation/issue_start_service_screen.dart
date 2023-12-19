import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';

import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';

import 'package:balady_plus/app/features/services/services_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_analytics_events.dart';
import '../../../core/utils/constants/dialog_names.dart';
import '../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../_shared_feature_/presentation/dialogs/not_authorized_indivivisual.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    ServiceEntity service = model();

    int? requestId = ModalRoute.of(context)!.settings.arguments as int?;

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ServiceCardsCubit(service),
          ),
        ],
        child: Scaffold(
          appBar: DefaultAppBarWidget(
            title: service.title,
            bottom: ServiceCardsList(
              cards: service.cards,
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  const Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        ServiceCardDescription(),
                      ],
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButtonWidget.startService(
                        onPressed: () async {
                          if (CommonProperties.isLoggedIn) {
                            if (CommonProperties.selectedDelegator != null) {
                              Navigator.of(context).pushNamed(
                                  RouteName.commercialLicensePage,
                                  arguments: requestId);
                            } else {
                              await BottomSheetDialog.showDraggableSheet(
                                context,
                                isFullHeight: false,
                                dialogKeyName:
                                    DialogName.notAuthorizedIndivisualDialog,
                                currentRouteName:
                                    RouteName.commercialLicenseServicePage,
                                child: NotAuthorizedIndivisualDialog(),
                              );
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (ctx) => NeedLoginDialog(
                                        onSuccessLogin:
                                            (bool? isSuccess) async {
                                      if (isSuccess ?? false) {
                                        if (CommonProperties
                                                .selectedDelegator !=
                                            null) {
                                          Navigator.of(context).pushNamed(
                                              RouteName.commercialLicensePage,
                                              arguments: requestId);
                                        } else {
                                          await BottomSheetDialog
                                              .showDraggableSheet(
                                            context,
                                            isFullHeight: false,
                                            dialogKeyName: DialogName
                                                .notAuthorizedIndivisualDialog,
                                            currentRouteName: RouteName
                                                .commercialLicenseServicePage,
                                            child:
                                                NotAuthorizedIndivisualDialog(),
                                          );
                                        }
                                      }
                                    }));
                          }
                        },
                      ),
                    ),
                  )
                  /* SafeArea(
                    top: false,
                    child: ServiceWarningWidget(
                      warning: service.warning ?? "",
                      onPress: () async {
                        Navigator.of(context).pushNamed(
                            RouteName.commercialLicensePage,
                            arguments: requestId);
                      },
                    ),
                  )*/
                ],
              ),
            ],
          ),
        ));
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
                "issue_service_req1"
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
}
