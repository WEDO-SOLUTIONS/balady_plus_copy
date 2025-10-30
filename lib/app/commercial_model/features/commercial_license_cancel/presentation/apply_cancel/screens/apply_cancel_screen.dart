import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/data/models/cancellation_rquest_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/apply_cancel/mvvm/apply_cancel_view_model.dart';
import 'package:balady_plus/app/features/services/presentation/mvvm/service_data_view_model.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/service_cards_dynamic/service_card_desc_widget.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/dialogs/custom_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';

class ApplyCancelScreen extends StatefulWidget {
  const ApplyCancelScreen({Key? key}) : super(key: key);

  @override
  State<ApplyCancelScreen> createState() => _ApplyCancelScreenState();
}

class _ApplyCancelScreenState extends State<ApplyCancelScreen> {
  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(
      AppEvents.cancelCommercialLicenseOpen,
    );
    CommonFunctions.sendUXCamEvent(
      UXCamEvents.startCardServiceCancelLicenseService,
    );

    CommonFunctions.sendUXCamEvent(
      UXCamEvents.CancelCommercialLicense_Open_Service_Card_Event,
    );
  }

  @override
  Widget build(BuildContext context) {
    ApplyCancelViewModel viewModel =
        ModalRoute.of(context)!.settings.arguments as ApplyCancelViewModel;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => viewModel,
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ServiceDataViewModel(
            webService: sl(),
            serviceId: RemoteConfig.MunicipalServicesIDs["CommercialLicenseCancel"]["id"],
          ),
        ),
      ],
      child: Scaffold(
        body: Column(
          children: [
            const Expanded(child: ServiceCardDescDynamicWidget()),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
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
                child: ElevatedButtonWidget.startService(
                  onPressed: () async {
                    NavigatorState navigator = Navigator.of(context);
                    CancellationRequestResponse? cancellationRequest =
                        await viewModel.applyCommercialLicenseCancellation();
                    if (cancellationRequest != null) {
                      navigator.popAndPushNamed(
                        CommercialRouteName.commercialLicenseCancel,
                        arguments: {
                          "from": "licenses",
                          "requestId": cancellationRequest.requestId,
                          "reasonCancel": viewModel.reasonCancel,
                          "availableCloseDate":
                              cancellationRequest.availableCloseDate,
                          "crNumber": viewModel.submitterInfo.crNumber ?? "",
                          "crType": viewModel.submitterInfo.crType!,
                        },
                      );
                      CommonFunctions.sendUXCamEvent(
                          UXCamEvents.startServiceCancelLicenseService);
                    } else if (viewModel.messageHtml != null) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (ctx) => CustomPopUp(
                          child: Html(
                            data: viewModel.messageHtml,
                            onLinkTap: (String? url,
                                Map<String, String> attributes, element) {
                              if (url != null) {
                                launchUrl(Uri.parse(url));
                              }
                            },
                          ),
                        ),
                      );
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
