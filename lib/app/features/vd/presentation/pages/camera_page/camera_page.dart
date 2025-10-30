import 'package:balady_plus/app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show
        CameraAppBar,
        cameraViewWidgetNew,
        photoPreviewWidgetNew,
        CameraBloc,
        CreateVDBloc,
        CameraState,
        ToggleCameraFlashEvent,
        CameraParamsPage;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';

class VDCameraPage extends StatefulWidget {
  VDCameraPage({
    super.key,
  });

  @override
  State<VDCameraPage> createState() => _VDCameraPageState();
}

class _VDCameraPageState extends State<VDCameraPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Helpers.sendEventToAnalytics(AppEvents.VD_Open_Camera); //MM
    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceSnapAndSend);
    CommonFunctions.sendUXCamEvent(UXCamEvents.cameraServiceSnapAndSend);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.SnapAndSend_Open_Camera_Step_Event);
  }

  @override
  Widget build(BuildContext context) {
    CameraParamsPage params =
        ModalRoute.of(context)!.settings.arguments as CameraParamsPage;

    return MultiBlocProvider(
      providers: [
        BlocProvider<CreateVDBloc>(
            create: (BuildContext context) => CreateVDBloc(
                // params: widget.params,
                getSplList: sl(),
                createIncidentRegistered: sl(),
                createIncidentUnRegistered: sl(),
                getGisData: sl(),
                getOTP: sl(),
                getSPLDetails: sl(),
                uploadFile: sl(),
                checkCR: sl())),
        BlocProvider<CameraBloc>(
            create: (BuildContext context) => CameraBloc(
                getSplList: sl(),
                params: params,
                getGisData: sl(),
                createVdBloc: context.read<CreateVDBloc>())),
      ],
      child: BlocConsumer<CameraBloc, CameraState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            /*appBar: CameraAppBar(
              flashOnPress: () {
                context.read<CameraBloc>().add(ToggleCameraFlashEvent());
              },
              isFlashOn: state.isFlashOn,
              showFlashIcon: state.showCamera ?? false,
            ),*/
            body: cameraViewWidgetNew(),
          );
        },
      ),
    );
  }
}
