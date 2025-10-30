import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../core/utils/animators/route_animator.dart';
import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../vd/domain/entities/camera/attachment_item.dart';
import '../../../../../vd/domain/entities/camera/camera_page_params.dart';
import '../../../../../vd/domain/entities/categories/category_item.dart';
import '../../../../../vd/domain/entities/create_vd_page_params.dart';
import '../../../../../vd/domain/entities/gis/gis_params.dart';
import '../../../../../vd/domain/entities/gis/gis_response.dart';
import '../../../../../vd/domain/entities/special_classifications/special_classifications_response.dart';
import '../../../../../vd/domain/use_cases/get_gis_data.dart';
import '../../../../../vd/domain/use_cases/get_special_classifications.dart';
import '../../../pages/create_dc_request/details_page/create_dc_page.dart';
import '../create_dc_details_bloc/create_dc_bloc.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

part 'dc_camera_event.dart';

part 'dc_camera_state.dart';

class DCCameraBloc extends Bloc<DCCameraEvent, DCCameraState> {
  CreateDCBloc createDCBloc;
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  final GetSpecialClassifications _getSplList;
  final GetGISData _getGisData;
  //final CheckActiveLocation _checkActiveLocation;

  bool initializingCamera = false;
  DCCameraBloc({required CameraParamsPage params, required this.createDCBloc})
      : _getSplList = GetSpecialClassifications(repository: sl()),
        _getGisData = GetGISData(repository: sl()),
        super(DCCameraState(
            selectedCattegory: params.selectedCategory!,
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
      if (cameras?.length != 0) {
        try {
          cameraController = CameraController(
              cameras![0], ResolutionPreset.medium,
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

    // add(InitCameraEvent());
  }

  Future<void> _getGisDataHandler(GetGISEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _getGisData(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      navigateToCreateVDPage();
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        gisResponse: success,
        location: e.params,
        errorMessage: "",
      ));
      navigateToCreateVDPage(location: e.params, gisResponse: success);
    });
  }

  Future<void> _getCurrenttUserLocationHandler(
      GetUserLocationEvent e, Emitter emitter) async {
    if (state.location == null && createDCBloc.state.location == null) {
      Position? position;
      try {
        emitter(state.copyWith(status: BlocStatus.loading));
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            timeLimit: const Duration(seconds: 20));
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
        navigateToCreateVDPage();
      }
    } else {
      navigateToCreateVDPage();
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
        String base64File = base64Encode(fileBytes);
        AttachmentItem item =
            AttachmentItem(base64: base64File, filePath: file?.path);

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
    emitter(state.copyWith(
        showCamera: true, files: [], isCameraInitialized: false));
  }

  Future<void> _showLoadingHandler(ShowLoading e, Emitter emitter) async {
    if (e.status)
      emitter(state.copyWith(status: BlocStatus.loading));
    else
      emitter(state.copyWith(status: BlocStatus.success));
  }

  Future<bool> _onNavigateToDetailsScreen(
      NavigateToDetailsScreenEvent e, Emitter emitter) async {
    /*
    if (state.status == BlocStatus.loading) return false;
    if (state.splResponse?.items?.isEmpty ?? true) {
      emitter(state.copyWith(status: BlocStatus.loading));
      final failureOrSuccess = await _getSplList(e.params);
      return failureOrSuccess.fold((failure) {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
        return false;
      }, (success) async {
        emitter(state.copyWith(
          status: BlocStatus.success,
          splResponse: success.data?.result,
          errorMessage: "",
        ));

        return navigateToCreateVDPage(e.createVDBloc);
      });
    } else {
      return navigateToCreateVDPage(e.createVDBloc);
    }*/
    return true;
  }

  bool navigateToCreateVDPage({GISParams? location, GISResponse? gisResponse}) {
    createDCBloc.add(EditCreateVDPageEvent(
        params: CreateVDParamsPage(
            files: state.files,
            selectedCategory: state.selectedCattegory,
            splResponse: state.splResponse,
            location: location,
            gisResponse: gisResponse,
            isFromHome: state.isFromHome ?? false)));
    NavigationService.navigatorKey.currentState?.push(SliderUpPage(
      page: BlocProvider<CreateDCBloc>.value(
        value: createDCBloc,
        child: CreateDCDetailsPage(),
      ),
    ));
    // NavigationService.navigatorKey.currentState!.push(MaterialPageRoute(
    //   builder: (context) => BlocProvider<CreateVDBloc>.value(
    //     value: createDCBloc,
    //     child: CreateVDDetailsPage(),
    //   ),
    // ));
    return true;
  }

  @override
  Future<void> close() async {
    super.close();

    cameraController?.dispose();
  }
}
