import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/services/presentation/mvvm/service_data_view_model.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/service_cards_dynamic/service_card_desc_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';

class CommercialLicenseOverviewScreen extends StatefulWidget {
  const CommercialLicenseOverviewScreen({Key? key}) : super(key: key);

  @override
  State<CommercialLicenseOverviewScreen> createState() =>
      _CommercialLicenseOverviewScreenState();
}

class _CommercialLicenseOverviewScreenState
    extends State<CommercialLicenseOverviewScreen> {
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
            serviceId: 11134,
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

                  //CommonFunctions.updateNotificationSettings(CommonProperties.fcmToken!);
                  navigator.pushNamed(CommercialRouteName.commercialLicenseQuery);
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
