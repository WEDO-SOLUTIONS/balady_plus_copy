import 'package:balady_plus/app/features/athkar/athkar_exports.dart'
    show AthkarAppBar, AthkarListView;
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/app_analytics_events.dart';
import '../../../../core/utils/common_functions.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColor.scaffoldBackground,
      appBar: AthkarAppBar(
        title: 'AthkarMainPageTitle'.tr(),
      ),
      body: AthkarListView(),
    );
  }
}
