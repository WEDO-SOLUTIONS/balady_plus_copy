import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/features/services/presentation/mvvm/service_data_view_model.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/service_cards_dynamic/service_card_desc_widget.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/dialogs/custom_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/app_analytics_events.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';

class ConstructionLicenseOverviewScreen extends StatefulWidget {
  const ConstructionLicenseOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ConstructionLicenseOverviewScreen> createState() =>
      _ConstructionLicenseOverviewScreenState();
}

class _ConstructionLicenseOverviewScreenState
    extends State<ConstructionLicenseOverviewScreen> {
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => ServiceDataViewModel(
            webService: sl(),
            serviceId: 11124,
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
              child: ElevatedButtonWidget.startService(
                onPressed: () async {
                  NavigatorState navigator = Navigator.of(context);

                  navigator.pushNamed(RouteName.constructionLicenseInquery);
                  // CommonFunctions.sendUXCamEvent(
                  //     UXCamEvents.startServiceQueryLicenseService);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
