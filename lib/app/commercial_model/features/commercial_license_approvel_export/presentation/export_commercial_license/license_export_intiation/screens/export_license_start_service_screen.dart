import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/not_authorized_indivivisual.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/services/presentation/mvvm/service_data_view_model.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/service_cards_dynamic/service_card_desc_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';

import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../../commercial_license/domain/entities/request_info_arragments.dart';
import '../blocs/commercial_license_export_bloc.dart';

class LicenseExportStartServicePage extends StatefulWidget {
  const LicenseExportStartServicePage({Key? key}) : super(key: key);

  @override
  State<LicenseExportStartServicePage> createState() => _LicenseExportStartServicePageState();
}

class _LicenseExportStartServicePageState extends State<LicenseExportStartServicePage> {

  int? initialApprovalRequestId;
  int? issuingRequestId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.issueCommercialLicenseOpen);
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.startCardServiceIssueACommercialLicense);
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.CommercialLicense_Open_Service_Card_Event);
    Future.microtask(() {
      sl<CommercialLicenseExportBloc>().applyLicenseExport(issuingRequestId);
    });
  }

  @override
  Widget build(BuildContext context) {
     var data = ModalRoute.of(context)!.settings.arguments as Map?;
     if(data != null)
       {
         initialApprovalRequestId = data["initialApprovalRequestId"] as int?;
         issuingRequestId = data["issuingRequestId"] as int?;
       }


    return
      MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: sl<CommercialLicenseExportBloc>(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => ServiceDataViewModel(
              webService: sl(),
              serviceId: 11010,
            ),
          ),
        ],
        child:
        BlocConsumer<CommercialLicenseExportBloc, CommercialLicenseExportState>(
            listener: (context, state) {},
            builder: (context, state) {return Stack(
                children:
                [
                  Scaffold(
                    body: state.detailsStatus == BlocStatus.success?
                    Column(
                      children: [
                        const Expanded(child: ServiceCardDescDynamicWidget()),
                        state.detailsStatus == BlocStatus.success? Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(36),
                              topRight: Radius.circular(36),
                            ),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 26),
                          child:

                          ElevatedButtonWidget.startService(
                            onPressed: () async {


                              if (CommonProperties.isLoggedIn) {
                                if (CommonProperties.selectedDelegator != null) {
                                  Navigator.of(context).pushNamed(
                                    CommercialRouteName.commercialLicensePage,
                                    arguments: RequestInfoArragments(requestId:state.requestId,isFromIntialApproval: true),

                                  );
                                } else {
                                  await BottomSheetDialog.showDraggableSheet(
                                    context,
                                    isFullHeight: false,
                                    dialogKeyName:
                                    DialogName.notAuthorizedIndivisualDialog,
                                    currentRouteName:
                                    CommercialRouteName.LicenseExportStartServicePage,
                                    child: NotAuthorizedIndivisualDialog(
                                        routName: CommercialRouteName.LicenseExportStartServicePage),
                                  );
                                }
                              }
                              else {
                                showDialog(
                                  context: context,
                                  builder: (ctx) =>
                                      NeedLoginDialog(
                                        onSuccessLogin: (bool? isSuccess) async {
                                          if (isSuccess ?? false) {
                                            if (CommonProperties.selectedDelegator !=
                                                null) {
                                              Navigator.of(context).pushNamed(
                                                CommercialRouteName.commercialLicensePage,
                                                arguments: RequestInfoArragments(requestId:initialApprovalRequestId,isFromIntialApproval: true),
                                              );
                                            } else {
                                              await BottomSheetDialog
                                                  .showDraggableSheet(
                                                context,
                                                isFullHeight: false,
                                                dialogKeyName: DialogName
                                                    .notAuthorizedIndivisualDialog,
                                                currentRouteName: CommercialRouteName
                                                    .LicenseExportStartServicePage,
                                                child: NotAuthorizedIndivisualDialog(
                                                  routName: CommercialRouteName
                                                      .LicenseExportStartServicePage,),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                );
                              }


                            },
                          ),
                        ):Container()
                      ],
                    ):
                    state.detailsStatus == BlocStatus.failure?
                    Stack(
                      children:
                      [
                        Image.asset(
                          ImagePath.backgroundServiceCard,
                          height: MediaQuery.of(context).size.height * .37,
                          width: double.maxFinite,
                          fit: BoxFit.fill,
                        ),
                      SizedBox.expand(
                        child: Column(
                          children: [


                            SizedBox(
                              height: MediaQuery.of(context).viewPadding.top,
                            ),
                            Row(
                              children: [
                                BackButton(color: Colors.white),
                                Text(
                                  'error'.tr(),
                                  style: AppStyle.violationCreateTitle
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                            ReloadWidget(
                              onTab: () {
                                sl<CommercialLicenseExportBloc>().applyLicenseExport(initialApprovalRequestId,);
                              },
                            ),
                          ],
                        ),
                      )
                      ],
                    ):
                    const Center(child: CustomCircularLoadingWidget()),
                  ),

                ]
            );  }));

  }


}
