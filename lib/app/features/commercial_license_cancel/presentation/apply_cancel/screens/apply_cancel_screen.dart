import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/data/models/cancellation_rquest_response.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/apply_cancel/mvvm/apply_cancel_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/blocs/commercial_license_cancel/commercial_license_cancel_bloc.dart';
import 'package:balady_plus/app/features/services/services_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/utils/app_analytics_events.dart';
import '../../../../../core/utils/common_functions.dart';

class ApplyCancelScreen extends StatefulWidget {
  const ApplyCancelScreen({Key? key}) : super(key: key);

  @override
  State<ApplyCancelScreen> createState() => _ApplyCancelScreenState();
}

class _ApplyCancelScreenState extends State<ApplyCancelScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.cancelCommercialLicenseOpen);
  }

  @override
  Widget build(BuildContext context) {
    ApplyCancelViewModel viewModel =
        ModalRoute.of(context)!.settings.arguments as ApplyCancelViewModel;
    ServiceEntity service = ServiceModel.fromJson(
      {
        "id": 1,
        "icon": "send_image",
        "3d_icon": null,
        "order": 1,
        "isNew": false,
        "isImportant": false,
        "action": {"type": "cards", "value": ""},
        "ar": {
          "title": "cancel_Service_name",
          "description": "",
          "tag": null,
          "warning": "cancel_service_warning"
        },
        "en": {
          "title": "cancel_Service_name",
          "description": "",
          "tag": null,
          "warning": "cancel_service_warning"
        },
        "cards": [
          {
            "iconName": IconPath.serviceCardDesc,
            "type": ServiceCardsTypes.desc,
            "rate": 0,
            "duration": "1 - 10 أيام",
            "fees": -1,
            "feesName": "calculator_fees",
            "feesLink": "https://apps.balady.gov.sa/Eservices/FeesCalculator",
            "ar": {
              "title": "service_describtion",
              "description": "cancel_service_desc"
            },
            "en": {"title": "Service Description", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardReq,
            "type": ServiceCardsTypes.req,
            "rate": 0,
            "duration": "0",
            "requirements": [
              "cancel_service_req",
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
                "title": "cancel_applying_benf",
                "steps": [
                  "cancel_applying_step1",
                  "cancel_applying_step2",
                  "cancel_applying_step3"
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
            "ar": {"title": "fines_penatlies", "description": "click_here"},
            "en": {"title": "Service Description", "description": ""}
          },
        ]
      },
    );

    return ChangeNotifierProvider(
      create: (BuildContext context) => viewModel,
      child: BlocProvider(
        create: (context) => ServiceCardsCubit(service),
        child: Scaffold(
          appBar: DefaultAppBarWidget(
            title: service.title,
            // actions: [
            //   Padding(
            //     padding: const EdgeInsetsDirectional.only(end: 10),
            //     child: InkWell(
            //       onTap: () async {
            //         try {
            //           sl<DelegatorsCubit>().getDelegators();
            //           await BottomSheetDialog.showDraggableSheet(
            //             context,
            //             dialogKeyName: DialogName.delegatorsDialog,
            //             currentRouteName: RouteName.createCompliancePage,
            //             child: DelegatorList(
            //               fromService: true,
            //               delegatorsCubit: sl<DelegatorsCubit>(),
            //             ),
            //           );
            //         } catch (ex) {
            //           print(ex);
            //         }
            //       },
            //       child: CircleIcon(
            //         icon: IconPath.switchProfileIcon,
            //         iconColor: AppColor.primary600Light,
            //         backgroundColor: AppColor.geyser.withOpacity(0.4),
            //         iconSize: 18,
            //       ),
            //     ),
            //   ),
            // ],
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
              SafeArea(
                top: false,
                child: Selector<ApplyCancelViewModel, bool>(
                  selector: (context, provider) => provider.isLoading,
                  builder: (BuildContext context, isLoading, Widget? child) {
                    return isLoading
                        ? const ShimmerEffectWidget(
                            height: 55,
                            borderRadius: 6,
                          )
                        : child!;
                  },
                  child: ServiceWarningWidget(
                    warning: service.warning ?? "",
                    onPress: () async {
                      NavigatorState navigator = Navigator.of(context);
                      CancellationRequestResponse? cancellationRequest =
                          await viewModel.applyCommercialLicenseCancellation();
                      if (cancellationRequest != null) {
                        navigator.popAndPushNamed(
                          RouteName.commercialLicenseCancel,
                          arguments: CommercialLicenseCancelBloc(
                            webService: sl(),
                            requestId: cancellationRequest.requestId,
                            availableCloseDate:
                                cancellationRequest.availableCloseDate,
                            crNumber: viewModel.submitterInfo.crNumber,
                            crType: viewModel.submitterInfo.crType,
                            reasonCancel: viewModel.reasonCancel,
                          ),
                        );
                      } else if (viewModel.messageHtml != null) {
                        showPopUpWidget(
                          context,
                          popUpBody: Html(
                              data: viewModel.messageHtml,
                              onLinkTap: (String? url,
                                  Map<String, String> attributes, element) {
                                //open URL in webview, or launch URL in browser, or any other logic here
                                if (url != null) {
                                  launchUrl(Uri.parse(url));
                                }
                              }),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
