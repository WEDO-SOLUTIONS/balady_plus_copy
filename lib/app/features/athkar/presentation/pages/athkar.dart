import 'package:balady_plus/app/features/athkar/athkar_exports.dart'
    show AthkarAppBar, AthkarListView;
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/app_analytics_events.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';

class Athkar extends StatefulWidget {
  Athkar({super.key});

  @override
  State<Athkar> createState() => _AthkarState();
}

class _AthkarState extends State<Athkar> {
  @override
  void initState() {
    super.initState();

    CommonFunctions.sendEventToAnalytics(AppEvents.Athkar);
    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceAthkar);
    CommonFunctions.sendUXCamEvent(UXCamEvents.Athkar_Open_Event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColor.scaffoldBackground,
      appBar: AthkarAppBar(
        title: "azkar".tr(),
      ),
      body: AthkarListView(),
    );
  }
}
