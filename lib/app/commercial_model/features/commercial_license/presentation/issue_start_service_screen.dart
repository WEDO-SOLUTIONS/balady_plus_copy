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

import '../domain/entities/request_info_arragments.dart';

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
                              arguments: RequestInfoArragments(requestId:requestId,isFromIntialApproval: false),

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
                                      arguments: RequestInfoArragments(requestId:requestId,isFromIntialApproval: false),
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
}
