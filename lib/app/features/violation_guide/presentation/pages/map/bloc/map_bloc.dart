import 'dart:async';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show MapScreenParams, GetGISData, GISParams, GISResponse;
import 'package:bloc/bloc.dart';
import 'package:dgis_map/dgis_map_controller.dart';
import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'dart:io';
import 'dart:math' show cos, sqrt, asin;

import '../../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetGISData _getGisData;
  late DgisMapController mapController;

  MapBloc({MapScreenParams? params})
      : _getGisData = GetGISData(repository: sl()),
        super(MapState(
          gisResponse: params?.gisResponse,
          location: params?.gisParams,
          userLocation: params?.currentUserLocation,
        )) {
    on<GetGISDataEvent>(_getGisDataHandler);
    on<InitMapEvent>(_initMapHandler);

    on<GetCurentUserLocationEvent>(_getCurrenttUserLocationHandler);
    on<SelectLocationEvent>(_selectLocationEventHandler);
  }

  Future<void> _getGisDataHandler(GetGISDataEvent e, Emitter emitter) async {
    if ((state.status == BlocStatus.loading)) return;
    emitter(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    GISParams params = e.params;

    final failureOrSuccess = await _getGisData(e.params);

    await failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        gisResponse: success,
        errorMessage: "",
      ));

      if (e.popPage) {
        NavigationService.navigatorKey.currentState
            ?.pop(MapScreenParams(gisParams: e.params, gisResponse: success));
      }
    });
  }

  Future<void> _getCurrenttUserLocationHandler(
      GetCurentUserLocationEvent e, Emitter emitter) async {
    try {
      emitter(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          timeLimit: const Duration(seconds: 20));
      emitter(state.copyWith(
          status: BlocStatus.success,
          location: GISParams(x: position.longitude, y: position.latitude),
          userLocation:
              GISParams(x: position.longitude, y: position.latitude)));
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      Position? position;
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
            location: GISParams(x: position.longitude, y: position.latitude),
            userLocation:
                GISParams(x: position.longitude, y: position.latitude)));
      }
    }

    add(GetGISDataEvent(
        params: state.location!, popPage: false, refreshLocation: true));

    animateCamera(state.location!.y, state.location!.x);
  }

  Future<void> _selectLocationEventHandler(
      SelectLocationEvent e, Emitter emitter) async {
    print("SelectLocationEvent");
    emitter(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

    emitter(state.copyWith(
        status: BlocStatus.success,
        isLocationAllowed: true,
        location: GISParams(x: e.location.longitude, y: e.location.latitude)));
    add(GetGISDataEvent(
        params: GISParams(x: e.location.longitude, y: e.location.latitude),
        popPage: false));
  }

  Future<void> _initMapHandler(InitMapEvent e, Emitter emitter) async {
    if (state.location != null && state.gisResponse == null) {
      add(GetGISDataEvent(params: state.location!, popPage: false));
    } else if (state.location != null && state.gisResponse != null) {
    } else {
      try {
        emitter(state.copyWith(status: BlocStatus.loading));

        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            timeLimit: const Duration(seconds: 20));
        emitter(state.copyWith(
            status: BlocStatus.success,
            location: GISParams(x: position.longitude, y: position.latitude),
            userLocation:
                GISParams(x: position.longitude, y: position.latitude)));
      } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
        Position? position;
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
              location: GISParams(x: position.longitude, y: position.latitude),
              userLocation:
                  GISParams(x: position.longitude, y: position.latitude)));
        }
      }

      if (state.location == null) {
        emitter(state.copyWith(
            status: BlocStatus.success,
            location: GISParams(
                x: CommonProperties.defaultLocation.longitude,
                y: CommonProperties.defaultLocation.latitude),
            userLocation: GISParams(
                x: CommonProperties.defaultLocation.longitude,
                y: CommonProperties.defaultLocation.latitude)));
      }
    }
    animateCamera(state.location!.y, state.location!.x);
  }

  void animateCamera(double lat, double lng) {
    try {


      // mapController.animateCamera(
      //   CameraUpdate.newCameraPosition(
      //     CameraPosition(target: LatLng(lat, lng), zoom: 16.0),
      //   ),
      // );

      mapController.moveCamera(
        CameraPositionMessage(
          point: GeoPointMessage(latitude: lat, longitude: lng),
          zoom: 16.0,
          tilt: 0.0,
          bearing: 0.0,
        ),
        0.3, // duration
        CameraAnimationTypeMessage.linear,
      );


    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) return 0;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  bool checkDistanceBetweenUserLocationAndSelectedLocation(
      {LatLng? userLocation, LatLng? selectedLocation}) {
    if (userLocation == null || selectedLocation == null) return false;
    double distanceInMeters = calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        selectedLocation.latitude,
        selectedLocation.longitude);

    if (distanceInMeters <= RemoteConfig.mapRadius) {
      return true;
    }
    return false;
  }

  static showCustomDialog(Widget dialog, {bool isDismiss = true}) {
    showDialog(
        context: NavigationService.navigatorKey.currentState!.context,
        barrierDismissible: isDismiss,
        builder: (ctx) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: dialog));
  }
}
