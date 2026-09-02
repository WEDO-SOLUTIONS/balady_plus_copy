import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../camera_bloc/camera_bloc.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget>
    with WidgetsBindingObserver {
  late CameraBloc bloc;

  // Raised when the lifecycle handler disposed an initialized camera, so
  // resume knows to re-create it (the controller reference itself is nulled
  // by disposeCamera and can no longer serve as that signal).
  bool _reinitCameraOnResume = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    bloc.disposeCamera();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    try {
      if (state == AppLifecycleState.inactive ||
          state == AppLifecycleState.paused) {
        final controller = bloc.cameraController;
        if (controller != null && controller.value.isInitialized) {
          _reinitCameraOnResume = true;
          bloc.disposeCamera();
        }
      } else if (state == AppLifecycleState.resumed) {
        if (_reinitCameraOnResume) {
          _reinitCameraOnResume = false;
          bloc.add(OnNewCameraSelected());
        }
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Assigned here, not in the post-frame callback: dispose() reads `bloc`,
    // and a fast pop used to hit LateInitializationError.
    bloc = context.read<CameraBloc>();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      bloc.add(InitCameraEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        // Guard on the live controller instance, not only the bloc flag: the
        // flag can lag one emit behind the controller's disposal.
        final cameraController = context.read<CameraBloc>().cameraController;
        final isCameraReady = (state.isCameraInitialized ?? false) &&
            cameraController != null &&
            cameraController.value.isInitialized;
        return Stack(
          children: [
            isCameraReady
                ? GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onScaleStart: (details) {
                      context
                          .read<CameraBloc>()
                          .add(SetZoomLevelEvent(zoom: state.scaleFactor));
                    },
                    onScaleUpdate: (details) {
                      context
                          .read<CameraBloc>()
                          .add(UpdateScaleLevelEvent(scale: details.scale));
                    },
                    child: SizedBox(
                      height: double.infinity,
                      // Non-null by isCameraReady; a boolean local does not
                      // promote the variable for the compiler.
                      child: CameraPreview(cameraController!),
                    ),
                  )
                : const Center(),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onScaleStart: (details) {
                context.read<CameraBloc>().add(
                      SetZoomLevelEvent(
                        zoom: state.scaleFactor,
                      ),
                    );
              },
              onScaleUpdate: (details) {
                context.read<CameraBloc>().add(
                      UpdateScaleLevelEvent(
                        scale: details.scale,
                      ),
                    );
              },
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 1.9,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.white, width: 2),
                        borderRadius: BorderRadius.circular(
                          24,
                        ),
                      ),
                    ),
                    const CustomVerticalSpace(height: 24),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
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
                          context.read<CameraBloc>().add(TakePhoto());
                        },
                        child: Image.asset(
                          IconPath.vdButtonCameraIcon,
                          height: 72,
                          width: 72,
                        )),
                    const CustomVerticalSpace(height: 30)
                  ],
                ),
              ),
            if (state.status == BlocStatus.loading)
              const Align(
                alignment: Alignment.center,
                child: CustomCircularLoadingWidget(),
              ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconButtonWidget(
                    icon: IconPath.vdCameraExit,
                    iconSize: 36,
                    btnHeight: 40,
                    btnWidth: 40,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CustomIconButtonWidget(
                    icon: !state.isFlashOn
                        ? IconPath.vdCameraFlashOff
                        : IconPath.vdCameraFlashOn,
                    iconSize: 32,
                    btnHeight: 32,
                    btnWidth: 32,
                    onPressed: () {
                      context.read<CameraBloc>().add(ToggleCameraFlashEvent());
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
