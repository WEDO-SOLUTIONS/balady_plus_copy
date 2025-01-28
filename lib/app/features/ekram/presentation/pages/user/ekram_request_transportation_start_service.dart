import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/driver_request_bloc/transport_requests_bloc.dart';
import 'package:balady_plus/app/features/services/presentation/mvvm/service_data_view_model.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/service_cards_dynamic/service_card_desc_widget.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/dialogs/custom_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EkramRequestTransportationStartService extends StatefulWidget {
  const EkramRequestTransportationStartService({Key? key}) : super(key: key);

  @override
  State<EkramRequestTransportationStartService> createState() =>
      _EkramRequestTransportationStartServiceState();
}

class _EkramRequestTransportationStartServiceState
    extends State<EkramRequestTransportationStartService> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.queryCommercialLicenseOpen);
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.startCardServiceQueryLicenseService);
  }

  @override
  Widget build(BuildContext context) {
    // TransportRequestsBloc? ekramRequestsBloc =
    //     ModalRoute.of(context)!.settings.arguments as TransportRequestsBloc?;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => ServiceDataViewModel(
            webService: sl(),
            serviceId: 11330,
          ),
        ),
      ],
      child: Scaffold(
        body: Column(
          children: [
            const Expanded(child: ServiceCardDescDynamicWidget()),
            Container(
                height: 100,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    color: AppColor.grayLight,
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: const Text(
                    'تشارككم وزارة البلديات والإسكان أحزانكم في وفاة فقيدكم، وتتقدم بخالص التعازي والمواساة لأسرته الكريمة، راجين لكم الصبر و السلوان',
                    textAlign: TextAlign.center)),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
              child: ElevatedButtonWidget.startService(
                onPressed: () async {
                  NavigationService.navigatorKey.currentState!.pushNamed(
                      RouteName.ekramRequestTransportationScreen,);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
