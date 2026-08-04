import 'package:balady_plus/super_app_js_bridge/camera/camera_widgets/camera_widget.dart';
import 'package:balady_plus/super_app_js_bridge/camera/camera_widgets/photo_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/core/utils/common_functions.dart';
import '../../app/core/utils/constants/analytics_events.dart';
import 'camera_bloc/camera_bloc.dart';

class VDCameraPage extends StatefulWidget {
  const VDCameraPage({super.key});

  @override
  State<VDCameraPage> createState() => _VDCameraPageState();
}

class _VDCameraPageState extends State<VDCameraPage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.startServiceSnapAndSend);
    CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.cameraServiceSnapAndSend);
    CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.SnapAndSend_Open_Camera_Step_Event);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<CameraBloc>(create: (BuildContext context) => CameraBloc())],
      child: Scaffold(
        body: BlocBuilder<CameraBloc, CameraState>(
          builder: (context, state) {
            return !(state.showCamera ?? false) ? const PhotoPreviewWidgetNew() : const CameraWidget();
          },
        ),
      ),
    );
  }
}
