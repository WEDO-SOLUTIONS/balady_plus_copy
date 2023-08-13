import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart' as Perm;
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/errors/errors_exports.dart'
    show NoDataFoundFailure, ServerFailure;
import '../../../../core/services/services_exports.dart'
    show NavigationService, NoParams;
import '../../../../core/utils/common_functions.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  // final GetObjectionRequests getRequests;

  LocationBloc() : super(const LocationState()) {
    on<GettingLocationPermissionEvent>(_getLocationPermission);
    on<GettingLocationDataEvent>(_getLocationData);
  }

  Future<void> _getLocationPermission(
      GettingLocationPermissionEvent e, Emitter emitter) async {
    Perm.ServiceStatus? serviceStatus =
        await Perm.Permission.location.serviceStatus;
    if (serviceStatus != Perm.ServiceStatus.disabled) {
      emitter(state.copyWith(
          locationPermissionStatus: BlocStatus.locationPermissionSuceess));

      var status = await Perm.Permission.location.request();
      if (status == Perm.PermissionStatus.permanentlyDenied) {
        emitter(state.copyWith(
            locationPermissionStatus: BlocStatus.locationPermissionFailed));
      } else if (status != Perm.PermissionStatus.granted) {
        PermissionStatus status = await Perm.Permission.location.request();

        if (status == Perm.PermissionStatus.granted) {
          emitter(state.copyWith(
              locationPermissionStatus: BlocStatus.locationPermissionSuceess));
        } else {
          emitter(state.copyWith(
              locationPermissionStatus: BlocStatus.locationPermissionFailed));
        }
      } else {
        emitter(state.copyWith(
            locationPermissionStatus: BlocStatus.locationPermissionSuceess));
      }
    } else {
      emitter(state.copyWith(
          locationPermissionStatus: BlocStatus.locationServiceFailed));
    }
  }

  Future<void> _getLocationData(
      GettingLocationDataEvent e, Emitter emitter) async {
    emitter(state.copyWith(locationStatus: BlocStatus.loading));

    LatLng? location = await Helpers.getCurrentLocation(
        accuracy: LocationAccuracy.high, duration: Duration(minutes: 2));
    if (location != null) {
      emitter(state.copyWith(locationStatus: BlocStatus.success));
    } else {
      emitter(state.copyWith(locationStatus: BlocStatus.failure));
    }
  }
}
