import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart' as Perm;
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/errors_exports.dart'
    show NoDataFoundFailure, ServerFailure;
import '../../../../core/services/services_exports.dart'
    show NavigationService, NoParams, sharedPrefs;
import '../../../../core/utils/common_functions.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final GetGISData _getGISData;

  LocationCubit()
      : _getGISData = GetGISData(repository: sl()),
        super(const LocationState()) {}

  Future<void> getLocationPermission() async {
    Perm.ServiceStatus? serviceStatus =
        await Perm.Permission.location.serviceStatus;
    if (serviceStatus != Perm.ServiceStatus.disabled) {
      emit(state.copyWith(
          locationServiceStatus: BlocStatus.locationServiceSuceess));

      var status = await Perm.Permission.location.request();
      if (status == Perm.PermissionStatus.permanentlyDenied) {
        emit(state.copyWith(
            locationPermissionStatus: BlocStatus.locationPermissionFailed));
      } else if (status != Perm.PermissionStatus.granted) {
        PermissionStatus status = await Perm.Permission.location.request();

        if (status == Perm.PermissionStatus.granted) {
          emit(state.copyWith(
              locationPermissionStatus: BlocStatus.locationPermissionSuceess));
        } else {
          emit(state.copyWith(
              locationPermissionStatus: BlocStatus.locationPermissionFailed));
        }
      } else {
        emit(state.copyWith(
            locationPermissionStatus: BlocStatus.locationPermissionSuceess));
      }
    } else {
      print("disabled");
      emit(state.copyWith(
          locationServiceStatus: BlocStatus.locationServiceFailed));
    }
  }

  Future<void> getLocationData() async {
    if (state.locationPermissionStatus != BlocStatus.locationPermissionSuceess)
      return;

    emit(state.copyWith(locationStatus: BlocStatus.loading));

    LatLng? location = await Helpers.getCurrentLocation(
        accuracy: LocationAccuracy.high, duration: Duration(minutes: 2));
    if (location != null) {
      emit(state.copyWith(
          locationStatus: BlocStatus.success,
          gisParams: GISParams(x: location.longitude, y: location.latitude)));
    } else {
      emit(state.copyWith(locationStatus: BlocStatus.failure));
    }
  }

  Future<void> getGISData() async {
    print("getGISData11");
    if (state.locationStatus == BlocStatus.success && state.gisParams != null) {
      emit(state.copyWith(requestsStatus: BlocStatus.loading));

      final failureOrSuccess = await _getGISData(state.gisParams!);

      failureOrSuccess.fold((l) {
        print("Succccceesss 33 $l");

        emit(state.copyWith(requestsStatus: BlocStatus.failure));
      }, (r) {
        sharedPrefs.setUserGISLoaction(r.toModel);
        sharedPrefs.setUserLocation(state.gisParams);
        print("Succccceesss $r");
        emit(
            state.copyWith(requestsStatus: BlocStatus.success, gisResponse: r));
      });
    }
  }

  Future<bool> getLocationCachedInit() async {
    GISParams? cachedLocation = await sharedPrefs.getUserLocation();
    GISResponse? cachedGIS = await sharedPrefs.getUserGISData();

    await getLocationPermission();

    if (cachedLocation != null &&
        cachedGIS != null &&
        (state.locationPermissionStatus ==
                BlocStatus.locationPermissionSuceess &&
            state.locationServiceStatus == BlocStatus.locationServiceSuceess)) {
      emit(state.copyWith(
          loadAppStatus: BlocStatus.success,
          requestsStatus: BlocStatus.success,
          gisResponse: cachedGIS,
          gisParams: cachedLocation));

      return true;
    } else {
      return false;
    }
  }

  Future<void> getLocationInit() async {
    if (state.locationStatus != BlocStatus.loading &&
        state.requestsStatus != BlocStatus.loading) {
      GISParams? cachedLocation = await sharedPrefs.getUserLocation();
      GISResponse? cachedGIS = await sharedPrefs.getUserGISData();

      await getLocationPermission();

      print("PERMISSIN ${state.locationPermissionStatus}");
      print("PERMISSIN ${state.locationServiceStatus}");
      print("PERMISSIN ${cachedLocation}");
      print("PERMISSIN ${cachedGIS}");

      if (cachedLocation != null &&
          cachedGIS != null &&
          (state.locationPermissionStatus ==
                  BlocStatus.locationPermissionSuceess &&
              state.locationServiceStatus ==
                  BlocStatus.locationServiceSuceess)) {
        print("HEREEE");
        print("HEREEE ${state.requestsStatus}");

        emit(state.copyWith(
            loadAppStatus: BlocStatus.success,
            requestsStatus: BlocStatus.success,
            gisResponse: cachedGIS,
            gisParams: cachedLocation));

        print("HEREEE ${state.requestsStatus}");
      }
      await getLocationData();
      await getGISData();
    }
  }
}
