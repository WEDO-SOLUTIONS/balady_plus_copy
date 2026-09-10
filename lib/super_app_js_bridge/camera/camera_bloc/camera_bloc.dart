import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';

import 'package:balady_plus/app/events_logs/balady_logs.dart';

import 'package:image/image.dart' as myImage;
import 'package:http/http.dart' as http;

import '../entities/camera/attachment_item.dart';

part 'camera_event.dart';

part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  bool initializingCamera = false;

  /// Runs while a teardown is still in flight. dispose() in camera 0.12 awaits
  /// the pending initialize before it closes the native session, so opening a
  /// new one meanwhile blocks on the device until the old one is released.
  Future<void>? _teardown;

  /// Drops the reference before disposing, so a rebuild can never hand a
  /// disposed controller to CameraPreview ("buildPreview() was called on a
  /// disposed CameraController"); the camera package keeps
  /// value.isInitialized true after dispose and exposes no isDisposed getter.
  Future<void> disposeCamera() async {
    final controller = cameraController;
    cameraController = null;
    if (controller == null) {
      return;
    }
    final teardown = _disposeController(controller);
    _teardown = teardown;
    try {
      await teardown;
    } finally {
      if (identical(_teardown, teardown)) {
        _teardown = null;
      }
    }
  }

  /// Never completes with an error: the lifecycle callback fires this without
  /// awaiting it, and _onNewCameraSelectedHandler awaits the same future.
  Future<void> _disposeController(CameraController controller) async {
    try {
      await controller.dispose();
    } on Object catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  /// Freezes the preview on its last frame without releasing the camera, for
  /// transient interruptions (Control Center, notification shade, the app
  /// switcher) where a full teardown costs seconds and buys nothing.
  Future<void> pausePreview() => _previewCall((controller) => controller.pausePreview());

  Future<void> resumePreview() => _previewCall((controller) => controller.resumePreview());

  /// The lifecycle callback is synchronous and cannot await these, so the
  /// CameraException the camera package rethrows would land in the zone as an
  /// unhandled error - the very flood this umbrella is closing.
  Future<void> _previewCall(Future<void> Function(CameraController) call) async {
    final controller = cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    try {
      await call(controller);
    } on CameraException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  CameraBloc() : super(CameraState()) {
    on<InitCameraEvent>(_onInit);
    on<TakePhoto>(_takePhotoHandler);
    on<ShowLoading>(_showLoadingHandler);
    on<OnNewCameraSelected>(_onNewCameraSelectedHandler);
    on<SetZoomLevelEvent>(_onSetZoomHandler);
    on<UpdateScaleLevelEvent>(_onUpdateScaleLevelHandler);
    on<ToggleCameraFlashEvent>(_onToggleCameraFlashHandler);
    on<ReTakePhotoEvent>(_onReTakePhotoHandler);
  }

  void _onInit(InitCameraEvent event, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    try {
      cameras = await availableCameras();
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      error.toString();
    }
    if (cameras?.isNotEmpty ?? false) {
      try {
        CameraDescription backCamera = cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras![0],
        );

        cameraController = CameraController(backCamera, ResolutionPreset.medium, enableAudio: false);
        initializingCamera = true;
        await cameraController?.initialize();
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      } finally {
        initializingCamera = false;
        // Only on a successfully initialized controller: on the failure path
        // setFlashMode throws the same 'Uninitialized CameraController'
        // exception out of this finally as an unawaited zone error.
        final controller = cameraController;
        if (controller != null && controller.value.isInitialized) {
          controller.setFlashMode(FlashMode.off);
        }
      }
    }
    emitter(
      state.copyWith(
        isFlashOn: false,
        status: BlocStatus.success,
        isCameraInitialized: cameraController?.value.isInitialized,
      ),
    );
  }

  Future<void> _takePhotoHandler(TakePhoto e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;
    try {
      emitter(state.copyWith(status: BlocStatus.loading));
      XFile? file = await cameraController?.takePicture();
      emitter(state.copyWith(status: BlocStatus.success, errorMessage: ""));
      final fileBytes = await file?.readAsBytes();
      if (fileBytes != null) {
        // String base64File = base64Encode(fileBytes);
        ///////////////////////////////////////////////////////////
        myImage.Image? decodeImg = myImage.decodeImage(fileBytes);
        // DateTime? dateTime = await fetchOnlineDateTimeForKSA();
        // String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(
        //   dateTime ?? DateTime.now(),
        // );
        // Define the black color
        myImage.drawString(decodeImg!, "", font: myImage.arial14, x: 100, y: 25, color: decodeImg.getColor(0, 0, 0));
        var encodeImage = myImage.encodeJpg(decodeImg, quality: 100);
        String base64Image = base64.encode(encodeImage);
        // String? miniType =
        //     CommonFunctions().guessMimeTypeFromBase64(base64Image);
        ///////////////////////////////////////////////////////////
        AttachmentItem item = AttachmentItem(base64: base64Image, encodeImage: encodeImage, filePath: file!.path);
        emitter(state.copyWith(status: BlocStatus.loading));
        bool showCamera = !(state.multi ?? false) ? false : true;
        emitter(
          state.copyWith(
            status: BlocStatus.success,
            files: item,
            showCamera: showCamera,
            isFlashOn: false,
            errorMessage: "",
          ),
        );
        //  await cameraController?.dispose();
      } else {
        emitter(state.copyWith(status: BlocStatus.failure, errorMessage: ""));
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      emitter(state.copyWith(status: BlocStatus.failure, errorMessage: error.toString()));
    }
  }

  Future<DateTime?> fetchOnlineDateTimeForKSA() async {
    try {
      // World Time API URL for Saudi Arabia (Asia/Riyadh)
      final url = Uri.parse('http://worldtimeapi.org/api/timezone/Asia/Riyadh');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final dateTimeString = data['datetime']; // Example: "2023-12-30T18:45:32.123456+03:00"
        return DateTime.parse(dateTimeString);
      } else {
        log('Failed to fetch time: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error fetching KSA date and time: $e');
      return null;
    }
  }

  Future<void> _onNewCameraSelectedHandler(OnNewCameraSelected e, Emitter emitter) async {
    // A resume can arrive while the previous re-init is still running (fast
    // lock/unlock); two overlapping initialize() calls fight for the device.
    if (initializingCamera) {
      return;
    }
    // The old controller is about to be (or already was) disposed - never
    // advertise it as initialized: a stale `true` here made the UI rebuild
    // CameraPreview with a dead controller.
    emitter(state.copyWith(status: BlocStatus.loading, isCameraInitialized: false));
    final previous = cameraController;
    final CameraDescription? description =
        previous?.description ??
        ((cameras?.isNotEmpty ?? false)
            ? cameras!.firstWhere(
                (camera) => camera.lensDirection == CameraLensDirection.back,
                orElse: () => cameras![0],
              )
            : null);
    cameraController = null;
    try {
      await previous?.dispose();
      // disposeCamera() already cleared the reference, so `previous` is null on
      // the lifecycle path and the await above is a no-op - the teardown it
      // started is the one that has to finish before the camera is free.
      await _teardown;
      if (description == null) {
        emitter(state.copyWith(status: BlocStatus.failure));
        return;
      }

      final CameraController controller = CameraController(description, ResolutionPreset.medium, enableAudio: false);
      cameraController = controller;
      initializingCamera = true;
      try {
        await controller.initialize();
      } finally {
        // Never leave the flag latched: it now gates re-init, so a throwing
        // initialize() would block every later attempt for good.
        initializingCamera = false;
      }
      controller.setFlashMode(FlashMode.off);
    } on CameraException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    emitter(
      state.copyWith(status: BlocStatus.success, isCameraInitialized: cameraController?.value.isInitialized ?? false),
    );
  }

  Future<void> _onSetZoomHandler(SetZoomLevelEvent e, Emitter emitter) async {
    emitter(state.copyWith(zoom: e.zoom));
  }

  Future<void> _onUpdateScaleLevelHandler(UpdateScaleLevelEvent e, Emitter emitter) async {
    double scale = state.zoom * e.scale;
    if (scale >= 1 && scale <= 7) {
      final controller = cameraController;
      if (controller == null || !controller.value.isInitialized) {
        // onScaleUpdate fires per pointer frame (~60/s); an unguarded
        // setZoomLevel on a not-yet-initialized controller throws
        // synchronously, bloc rethrows it into the zone, and telemetry
        // was billed one event per frame of pinching on a black preview.
        return;
      }
      try {
        controller.setZoomLevel(scale);
      } on CameraException {
        // Controller torn down between the check and the call - drop the sample.
      }
      emitter(state.copyWith(scaleFactor: scale));
    }
  }

  Future<void> _onToggleCameraFlashHandler(ToggleCameraFlashEvent e, Emitter emitter) async {
    try {
      if (state.isCameraInitialized == true) {
        if (state.isFlashOn) {
          await cameraController!.setFlashMode(FlashMode.off);

          emitter(state.copyWith(isFlashOn: false));
        } else {
          await cameraController!.setFlashMode(FlashMode.always);

          emitter(state.copyWith(isFlashOn: true));
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

  Future<void> _onReTakePhotoHandler(ReTakePhotoEvent e, Emitter emitter) async {
    emitter(state.copyWith(showCamera: true, isCameraInitialized: false));
  }

  Future<void> _showLoadingHandler(ShowLoading e, Emitter emitter) async {
    if (e.status) {
      emitter(state.copyWith(status: BlocStatus.loading));
    } else {
      emitter(state.copyWith(status: BlocStatus.success));
    }
  }

  @override
  Future<void> close() async {
    super.close();
    await disposeCamera();
  }
}
