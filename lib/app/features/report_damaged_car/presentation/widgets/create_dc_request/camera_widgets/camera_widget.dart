import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../blocs/create_dc_request/camera_bloc/dc_camera_bloc.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget>
    with WidgetsBindingObserver {
  late DCCameraBloc bloc;
  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    bloc.cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (context.read<DCCameraBloc>().cameraController == null ||
        !context.read<DCCameraBloc>().cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      context.read<DCCameraBloc>().cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      context.read<DCCameraBloc>().add(OnNewCameraSelected());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<DCCameraBloc>().add(InitCameraEvent());
      bloc = context.read<DCCameraBloc>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DCCameraBloc, DCCameraState>(
      builder: (context, state) {
        return Stack(
          children: [
            (state.isCameraInitialized ?? false)
                ? GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onScaleStart: (details) {
                      context
                          .read<DCCameraBloc>()
                          .add(SetZoomLevelEvent(zoom: state.scaleFactor));
                    },
                    onScaleUpdate: (details) {
                      context
                          .read<DCCameraBloc>()
                          .add(UpdateScaleLevelEvent(scale: details.scale));
                    },
                    child: SizedBox(
                        height: double.infinity,
                        child: Container(
                            child: CameraPreview(context
                                .read<DCCameraBloc>()
                                .cameraController!))),
                  )
                : const Center(),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onScaleStart: (details) {
                context
                    .read<DCCameraBloc>()
                    .add(SetZoomLevelEvent(zoom: state.scaleFactor));
              },
              onScaleUpdate: (details) {
                context
                    .read<DCCameraBloc>()
                    .add(UpdateScaleLevelEvent(scale: details.scale));
              },
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 1.9,
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColor.white, width: 2),
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    CustomVerticalSpace(height: 24),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      child: CustomTextWidget(
                        ("vd_camera").tr(),
                        fontSize: 14,
                        height: 1.2,
                        fontWeight: AppFontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (state.isCameraInitialized == true)
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // take photo button
                    GestureDetector(
                        onTap: () async {
                          context.read<DCCameraBloc>().add(TakePhoto());
                        },
                        child: Image.asset(
                          IconPath.vdButtonCameraIcon,
                          height: 72,
                          width: 72,
                        )),
                    CustomVerticalSpace(height: 30)
                  ],
                ),
              ),
            if (state.status == BlocStatus.loading)
              Align(
                  alignment: Alignment.center,
                  child: CustomCircularLoadingWidget()),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconButtonWidget(
                    icon: IconPath.vdCameraExit,
                    iconSize: 36,
                    btnHeight: 40,
                    btnWidth: 40,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CustomIconButtonWidget(
                    icon: state.isFlashOn
                        ? IconPath.vdCameraFlashOff
                        : IconPath.vdCameraFlashOn,
                    iconSize: 36,
                    btnHeight: 40,
                    btnWidth: 40,
                    onPressed: () {
                      context
                          .read<DCCameraBloc>()
                          .add(ToggleCameraFlashEvent());
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
