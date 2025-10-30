import 'package:balady_plus/app/features/athkar/athkar_exports.dart'
    show AthkarAppBar, AthkarEntitiesListView, AthkarEntitiesParams;
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';

class AthkarEntities extends StatefulWidget {
  const AthkarEntities({super.key});

  @override
  State<AthkarEntities> createState() => _AthkarEntitiesState();
}

class _AthkarEntitiesState extends State<AthkarEntities> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.Athkar_Open_Category_Event);
  }

  @override
  Widget build(BuildContext context) {
    AthkarEntitiesParams params =
        ModalRoute.of(context)!.settings.arguments as AthkarEntitiesParams;
    return Scaffold(
      // backgroundColor: AppColor.scaffoldBackground,
      appBar: AthkarAppBar(title: "azkar".tr()),
      body:
          AthkarEntitiesListView(athkarEntitiesList: params.athkarEntitiesList),
    );
  }
}
