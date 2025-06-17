import 'dart:convert';

import 'package:balady_plus/app/core/services/services_exports.dart'
    show NavigationService;
import 'package:balady_plus/app/core/utils/animators/route_animator.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';

import 'package:balady_plus/app/core/errors/errors_exports.dart'
    show ServerFailure;
import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:geolocator/geolocator.dart';

import 'package:balady_plus/app/events_logs/balady_logs.dart';

import 'package:image/image.dart' as myImage;
import 'package:http/http.dart' as http;

import '../../../app/features/location/domain/entities/gis/gis_params.dart';
import '../../../app/features/location/domain/entities/gis/gis_response.dart';
import '../../../app/features/location/domain/use_cases/get_gis_data.dart';
import '../camera_page.dart';
import '../entities/camera/attachment_item.dart';
import '../special_classifications/special_classifications_response.dart';

part 'camera_event.dart';

part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  final GetGISData _getGisData;
  bool initializingCamera = false;

  CameraBloc(
      {required GetGISData getGisData,
      required CameraParamsPage params})
      :_getGisData = getGisData,
        super(CameraState(
          location: (params.lat != null && params.lon != null)
              ? GISParams(x: params.lon!, y: params.lat!)
              : null,
          qrCodeFlow: params.qrCodeFlow,
          pageType: params.pageType,
          selectedCattegory: params.selectedCategory!,
          // isFromHome: params.isFromHome,
        )) {
    on<InitCameraEvent>((event, emit) async {
      emit(state.copyWith(status: BlocStatus.loading));
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
          // Find back camera in the available cameras
          CameraDescription backCamera = cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
            orElse: () => cameras![0],
          );

          cameraController = CameraController(
              backCamera, ResolutionPreset.medium,
              enableAudio: false);
          initializingCamera = true;
          await cameraController?.initialize();
          initializingCamera = false;
          cameraController?.setFlashMode(FlashMode.off);
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
      emit(state.copyWith(
          isFlashOn: false,
          status: BlocStatus.success,
          isCameraInitialized: cameraController?.value.isInitialized));
    });
    //on<GetSplListEvent>(_getVDSplListHandler);
    on<TakePhoto>(_takePhotoHandler);
    on<ShowLoading>(_showLoadingHandler);
    on<OnNewCameraSelected>(_onNewCameraSelectedHandler);
    on<SetZoomLevelEvent>(_onSetZoomHandler);
    on<UpdateScaleLevelEvent>(_onUpdateScaleLevelHandler);

    on<ToggleCameraFlashEvent>(_onToggleCameraFlashHandler);
    on<ReTakePhotoEvent>(_onReTakePhotoHandler);

    on<NavigateToDetailsScreenEvent>(_onNavigateToDetailsScreen);

    on<GetGISEvent>(_getGisDataHandler);
    on<GetUserLocationEvent>(_getCurrenttUserLocationHandler);
  }

  Future<void> _getGisDataHandler(GetGISEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _getGisData(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      ///TODO: send action to js bridge
      // navigateToCreateVDPage();
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        gisResponse: success,
        location: e.params,
        errorMessage: "",
      ));
      ///TODO: send action to js bridge
      // navigateToCreateVDPage(location: e.params, gisResponse: success);
    });
  }

  Future<void> _getCurrenttUserLocationHandler(
      GetUserLocationEvent e, Emitter emitter) async {
    if (state.location == null) {
      Position? position;
      try {
        emitter(state.copyWith(status: BlocStatus.loading));
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          timeLimit: const Duration(seconds: 20),
        );
        emitter(state.copyWith(status: BlocStatus.success));
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
        try {
          position = await Geolocator.getLastKnownPosition();
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        if (position != null) {
          emitter(state.copyWith(
            status: BlocStatus.success,
          ));
        }
      }
      if (position != null) {
        add(GetGISEvent(
            params: GISParams(x: position.longitude, y: position.latitude)));
      } else {
        ///TODO: send action to js bridge
        // navigateToCreateVDPage();
      }
    } else {
      if (state.qrCodeFlow == true &&
          state.location?.x != null &&
          state.location?.x != null) {
        add(GetGISEvent(
            params: GISParams(x: state.location!.x, y: state.location!.y)));
      } else {
        ///TODO: send action to js bridge
        // navigateToCreateVDPage();
      }
    }
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
        myImage.drawString(
          decodeImg!,
          "",
          font: myImage.arial14,
          x: 100,
          y: 25,
          color: decodeImg.getColor(0, 0, 0),
        );
        var encodeImage = myImage.encodeJpg(decodeImg, quality: 100);
        String base64Image = base64.encode(encodeImage);
        String? miniType =
            CommonFunctions().guessMimeTypeFromBase64(base64Image);
        ///////////////////////////////////////////////////////////
        AttachmentItem item = AttachmentItem(
          base64: base64Image,
          encodeImage: encodeImage,
          filePath: "${file!.path}.${miniType?.split('/').last ?? "jpeg"}",
        );
        emitter(state.copyWith(status: BlocStatus.loading));

        List<AttachmentItem> items = state.files ?? [];
        if (!(state.multi ?? false)) {
          items.clear();
          item.index = items.length;
          items.add(item);
        }
        bool showCamera = !(state.multi ?? false) ? false : true;
        emitter(state.copyWith(
          status: BlocStatus.success,
          files: items,
          showCamera: showCamera,
          isFlashOn: false,
          errorMessage: "",
        ));
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
      emitter(state.copyWith(
          status: BlocStatus.failure, errorMessage: error.toString()));
    }
  }

  Future<DateTime?> fetchOnlineDateTimeForKSA() async {
    try {
      // World Time API URL for Saudi Arabia (Asia/Riyadh)
      final url = Uri.parse('http://worldtimeapi.org/api/timezone/Asia/Riyadh');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final dateTimeString =
            data['datetime']; // Example: "2023-12-30T18:45:32.123456+03:00"
        return DateTime.parse(dateTimeString);
      } else {
        print('Failed to fetch time: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching KSA date and time: $e');
      return null;
    }
  }

  Future<void> _onNewCameraSelectedHandler(
      OnNewCameraSelected e, Emitter emitter) async {
    emitter(state.copyWith(
        status: BlocStatus.loading,
        isCameraInitialized: cameraController?.value.isInitialized));
    try {
      if (cameraController != null) {
        await cameraController?.dispose();
      }
      emitter(state.copyWith(status: BlocStatus.loading));

      final CameraController _controller = CameraController(
          cameraController!.description, ResolutionPreset.medium,
          enableAudio: false);
      cameraController = _controller;
      initializingCamera = true;
      await _controller.initialize();
      initializingCamera = false;
      _controller.setFlashMode(FlashMode.off);
    } on CameraException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    emitter(state.copyWith(
        status: BlocStatus.success,
        isCameraInitialized: cameraController?.value.isInitialized));
  }

  Future<void> _onSetZoomHandler(SetZoomLevelEvent e, Emitter emitter) async {
    emitter(state.copyWith(zoom: e.zoom));
  }

  Future<void> _onUpdateScaleLevelHandler(
      UpdateScaleLevelEvent e, Emitter emitter) async {
    double scale = state.zoom * e.scale;
    if (scale >= 1 && scale <= 7) {
      cameraController?.setZoomLevel(scale);
      emitter(state.copyWith(scaleFactor: scale));
    }
  }

  Future<void> _onToggleCameraFlashHandler(
      ToggleCameraFlashEvent e, Emitter emitter) async {
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

  Future<void> _onReTakePhotoHandler(
      ReTakePhotoEvent e, Emitter emitter) async {
    emitter(
      state.copyWith(showCamera: true, files: [], isCameraInitialized: false),
    );
  }

  Future<void> _showLoadingHandler(ShowLoading e, Emitter emitter) async {
    if (e.status) {
      emitter(state.copyWith(status: BlocStatus.loading));
    } else {
      emitter(state.copyWith(status: BlocStatus.success));
    }
  }

  Future<bool> _onNavigateToDetailsScreen(
      NavigateToDetailsScreenEvent e, Emitter emitter) async {
    return true;
  }

  @override
  Future<void> close() async {
    super.close();
    cameraController?.dispose();
  }
}
