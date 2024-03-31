import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/profile_features/delegators/delegators_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, DefaultAppBarWidget, ElevatedButtonWidget;
import '../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../../services/data/models/service_model.dart';
import '../../../services/domain/entities/service_entity.dart';
import '../../../services/presentation/cubit/service_cards_cubit/service_cards_cubit.dart';
import '../../../services/presentation/widgets/service_card_description.dart';
import '../../../services/presentation/widgets/service_cards_list.dart';
import '../../../services/presentation/widgets/service_warning_widget.dart';
import '../widgets/create_compliance_location_widgets/create_compliance_widget.dart';

class CreateComplianceLocationPage extends StatefulWidget {
  const CreateComplianceLocationPage({
    super.key,
  });

  @override
  State<CreateComplianceLocationPage> createState() => _ServiceCardsPageState();
}

class _ServiceCardsPageState extends State<CreateComplianceLocationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.startCardServiceComplianceCertificate);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Compliance_Certificate_Open_Service_Card_Event);
  }

  @override
  Widget build(BuildContext context) {
    ServiceEntity service = serviceModel;
    return BlocProvider(
      create: (context) => ServiceCardsCubit(service),
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: service.title.tr(),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: InkWell(
                onTap: () async {
                  try {
                    sl<DelegatorsCubit>().getDelegators();
                    sl<DelegatorsCubit>().getAgents();
                    await BottomSheetDialog.showDraggableSheet(
                      context,
                      dialogKeyName: DialogName.delegatorsDialog,
                      currentRouteName: RouteName.createCompliancePage,
                      child: DelegatorList(
                        fromService: true,
                        delegatorsCubit: sl<DelegatorsCubit>(),
                      ),
                    );
                  } catch (ex) {}
                },
                child: CircleIcon(
                  icon: IconPath.switchProfileIcon,
                  iconColor: AppColor.primary600Light,
                  backgroundColor: AppColor.geyser.withOpacity(0.4),
                  iconSize: 18,
                ),
              ),
            ),
          ],
          bottom: ServiceCardsList(
            cards: service.cards,
          ),
        ),
        body: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    ServiceCardDescription(),
                  ],
                ),
              ),
            ),
            /* if (service.warning != null)
              ServiceWarningWidget(
                warning: service.warning ?? "",
                onPress: () {
                  BottomSheetDialog.showDraggableSheet(context,
                      // dialogKeyName: DialogName.dcVeichlesDialog,
                      // currentRouteName: RouteName.DCVeichlePage,

                      isFullHeight: false,
                      child: CreateComplianceLocationWidget());
                },
              )
            else*/
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButtonWidget.startService(
                  onPressed: () async {
                    bool isLocationAvailable =
                        await CommonFunctions.checkLocationSettings(context);

                    if (isLocationAvailable) {
                      if (CommonProperties.isLoggedIn) {
                        BottomSheetDialog.showDraggableSheet(context,
                            dialogKeyName:
                                DialogName.complianceConfirmLocationDialog,
                            currentRouteName: RouteName.createCompliancePage,
                            isFullHeight: false,
                            child: CreateComplianceLocationWidget());
                      } else {
                        showDialog(
                            context: context,
                            builder: (ctx) => NeedLoginDialog(
                                    onSuccessLogin: (bool? isSuccess) async {
                                  if (isSuccess ?? false) {
                                    BottomSheetDialog.showDraggableSheet(
                                        context,
                                        dialogKeyName: DialogName
                                            .complianceConfirmLocationDialog,
                                        currentRouteName:
                                            RouteName.createCompliancePage,
                                        isFullHeight: false,
                                        child:
                                            CreateComplianceLocationWidget());
                                  }
                                }));
                      }
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

ServiceModel get serviceModel => ServiceModel.fromJson(
      {
        "id": 1,
        "icon": "send_image",
        "3d_icon": null,
        "order": 1,
        "isNew": false,
        "isImportant": false,
        "action": {"type": "cards", "value": ""},
        "ar": {
          "title": "complaince_service_name",
          "description": "",
          "tag": null,
          "warning": ""
        },
        "en": {
          "title": "Send Image",
          "description":
              "Improve the civil scene of your city and report visual pollution",
          "tag": null,
          "warning": ""
        },
        "cards": [
          {
            "iconName": IconPath.serviceCardDesc,
            "type": ServiceCardsTypes.desc,
            "rate": 0,
            "duration": "0",
            "fees": 0,
            "ar": {
              "title": "service_desc",
              "description": "complaince_service_desc"
            },
            "en": {"title": "Service Description", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardReq,
            "type": ServiceCardsTypes.req,
            "rate": 0,
            "duration": "0",
            "requirements": [
              "complaince_service_req_1",
              "complaince_service_req_2"
            ],
            "ar": {"title": "requirements", "description": ""},
            "en": {"title": "Requirements", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardFlow,
            "type": ServiceCardsTypes.flow,
            "rate": 0,
            "duration": "0",
            "flow": [
              {
                "title": "complaince_applying_benf",
                "steps": [
                  "complaince_applying_benf_step_1",
                  "complaince_applying_benf_step_2",
                  "complaince_applying_benf_step_3",
                  "complaince_applying_benf_step_4",
                  "complaince_applying_benf_step_5",
                  "complaince_applying_benf_step_6",
                  "complaince_applying_benf_step_7",
                ]
              },
              {
                "title": "complaince_applying_end",
                "steps": [
                  "complaince_applying_end_step_1",
                  "complaince_applying_end_step_2",
                  "complaince_applying_end_step_3",
                  "complaince_applying_end_step_4",
                  "complaince_applying_end_step_5",
                  "complaince_applying_end_step_6",
                  "complaince_applying_end_step_7",
                ]
              }
            ],
            "ar": {"title": "applying_steps", "description": ""},
            "en": {"title": "", "description": ""}
          }
        ]
      },
    );
