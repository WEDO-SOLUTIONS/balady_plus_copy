import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_response.dart';
import 'package:balady_plus/app/features/location/domain/use_cases/get_gis_data.dart';
import 'package:balady_plus/app/features/location/gis_response_model.dart';
import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:permission_handler/permission_handler.dart' as Perm;
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/services_exports.dart' show sharedPrefs;

part 'location_event.dart';
part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final GetGISData _getGISData;

  LocationCubit() : _getGISData = GetGISData(repository: sl()), super(const LocationState());

  /// Clears the one-shot success flag so the page does not react to it twice.
  /// Lives here because `emit` is protected: the page used to call it directly.
  void resetRequestsStatus() {
    emit(state.copyWith(requestsStatus: BlocStatus.initial));
  }

  Future<void> getLocationPermission() async {
    Perm.ServiceStatus? serviceStatus = await Perm.Permission.location.serviceStatus;
    if (serviceStatus != Perm.ServiceStatus.disabled) {
      emit(state.copyWith(locationServiceStatus: BlocStatus.locationServiceSuceess));

      var status = await Perm.Permission.location.request();
      if (status == Perm.PermissionStatus.permanentlyDenied) {
        emit(state.copyWith(locationPermissionStatus: BlocStatus.locationPermissionFailed));
      } else if (status != Perm.PermissionStatus.granted) {
        PermissionStatus status = await Perm.Permission.location.request();

        if (status == Perm.PermissionStatus.granted) {
          emit(state.copyWith(locationPermissionStatus: BlocStatus.locationPermissionSuceess));
        } else {
          emit(state.copyWith(locationPermissionStatus: BlocStatus.locationPermissionFailed));
        }
      } else {
        emit(state.copyWith(locationPermissionStatus: BlocStatus.locationPermissionSuceess));
      }
    } else {
      emit(state.copyWith(locationServiceStatus: BlocStatus.locationServiceFailed));
    }
  }

  Future<void> getLocationData() async {
    if (state.locationPermissionStatus != BlocStatus.locationPermissionSuceess) {
      return;
    }

    emit(state.copyWith(locationStatus: BlocStatus.loading));

    LatLng? location = await Helpers.getCurrentLocation(
      accuracy: LocationAccuracy.medium,
      duration: Duration(seconds: 1),
    );

    if (location != null) {
      emit(
        state.copyWith(
          locationStatus: BlocStatus.success,
          gisParams: GISParams(x: location.longitude, y: location.latitude),
        ),
      );
    } else {
      emit(state.copyWith(locationStatus: BlocStatus.failure));
    }
  }

  Future<void> getGISData() async {
    if (state.locationStatus == BlocStatus.success && state.gisParams != null) {
      emit(state.copyWith(requestsStatus: BlocStatus.loading));

      final failureOrSuccess = await _getGISData(state.gisParams!);

      failureOrSuccess.fold(
        (l) {
          emit(state.copyWith(requestsStatus: BlocStatus.failure));
        },
        (r) {
          sharedPrefs.setUserGISLoaction(r.toModel);
          sharedPrefs.setUserLocation(state.gisParams);
          emit(state.copyWith(requestsStatus: BlocStatus.success, gisResponse: r));
        },
      );
    }
  }

  Future<bool> getLocationCachedInit() async {
    GISParams? cachedLocation = await sharedPrefs.getUserLocation();
    GISResponse? cachedGIS = await sharedPrefs.getUserGISData();

    await getLocationPermission();

    if (cachedLocation != null &&
        cachedGIS != null &&
        (state.locationPermissionStatus == BlocStatus.locationPermissionSuceess &&
            state.locationServiceStatus == BlocStatus.locationServiceSuceess)) {
      emit(
        state.copyWith(
          loadAppStatus: BlocStatus.success,
          requestsStatus: BlocStatus.success,
          gisResponse: cachedGIS,
          gisParams: cachedLocation,
        ),
      );

      return true;
    } else {
      return false;
    }
  }

  Future<void> getLocationInit() async {
    if (state.locationStatus != BlocStatus.loading && state.requestsStatus != BlocStatus.loading) {
      GISParams? cachedLocation = await sharedPrefs.getUserLocation();
      GISResponse? cachedGIS = await sharedPrefs.getUserGISData();
      await getLocationPermission();

      if (cachedLocation != null &&
          cachedGIS != null &&
          (state.locationPermissionStatus == BlocStatus.locationPermissionSuceess &&
              state.locationServiceStatus == BlocStatus.locationServiceSuceess)) {
        emit(
          state.copyWith(
            loadAppStatus: BlocStatus.success,
            requestsStatus: BlocStatus.success,
            gisResponse: cachedGIS,
            gisParams: cachedLocation,
          ),
        );
      }

      await getLocationData();
      await getGISData();
    }
  }
}
