import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_response.dart';
import 'package:balady_plus/app/features/location/domain/use_cases/get_gis_data.dart';
import 'package:balady_plus/app/features/location/gis_response_model.dart';
import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/services_exports.dart' show sharedPrefs;

part 'location_event.dart';
part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final GetGISData _getGISData;

  LocationCubit() : _getGISData = GetGISData(repository: sl()), super(const LocationState());

  bool _permissionRequestInFlight = false;
  AppLifecycleListener? _resumeRetry;

  Future<void> getLocationPermission() async {
    // Fires from AuthCubit's post-frame AND from every resume of
    // AcquireLocationPage - two concurrent request() calls get rejected by
    // the platform side just like the no-Activity case.
    if (_permissionRequestInFlight) {
      return;
    }
    // permission_handler needs an attached foreground Activity. A request from
    // the background throws PlatformException(Unable to detect current Android
    // Activity) - that flood was 43% of all our exception traffic. `null`
    // lifecycle = cold start before the first lifecycle event: proceed, the
    // catch below covers the rare loss of the race with Activity attach.
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (lifecycle != null && lifecycle != AppLifecycleState.resumed) {
      _scheduleRetryOnResume();
      return;
    }
    _permissionRequestInFlight = true;
    try {
      perm.ServiceStatus? serviceStatus = await perm.Permission.location.serviceStatus;
      if (serviceStatus == perm.ServiceStatus.disabled) {
        emit(state.copyWith(locationServiceStatus: BlocStatus.locationServiceFailed));
        return;
      }
      emit(state.copyWith(locationServiceStatus: BlocStatus.locationServiceSuceess));

      // Exactly one request: the OS never re-prompts for a just-denied
      // permission in the same foreground pass, so the old immediate second
      // request() was pure noise doubling the no-Activity exposure window.
      var status = await perm.Permission.location.request();
      emit(
        state.copyWith(
          locationPermissionStatus: status == perm.PermissionStatus.granted
              ? BlocStatus.locationPermissionSuceess
              : BlocStatus.locationPermissionFailed,
        ),
      );
    } on PlatformException {
      // No Activity attached (cold start race / backgrounded mid-request).
      // Silent one-shot retry on the next resume instead of a report.
      _scheduleRetryOnResume();
    } finally {
      _permissionRequestInFlight = false;
    }
  }

  void _scheduleRetryOnResume() {
    if (_resumeRetry != null) {
      return;
    }
    _resumeRetry = AppLifecycleListener(
      onResume: () {
        _resumeRetry?.dispose();
        _resumeRetry = null;
        getLocationPermission();
      },
    );
  }

  @override
  Future<void> close() {
    _resumeRetry?.dispose();
    _resumeRetry = null;
    return super.close();
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
