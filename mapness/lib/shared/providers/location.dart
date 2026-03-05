import 'dart:async';
import 'dart:io';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:dgis_map/library.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location.g.dart';

final locationProvider = _locationProvider;

@Riverpod(keepAlive: true)
class _Location extends _$Location {
  final _saRect = GeoRectMessage(
    northEast: GeoPointMessage(latitude: 32.568765, longitude: 56.694472),
    southWest: GeoPointMessage(latitude: 15.506104, longitude: 32.61185),
  );

  @override
  Position? build() {
    checkLocationPermission(showGiveAccessSheet: false).then((permitted) async {
      if (!permitted) {
        return;
      }
      final isGmsAvailable = await CommonFunctions.isGmsAvailable();
      final isHMS = await CommonFunctions.isHuaweiDevice();

      // gms is not available on iOS so we use the standard library in the case
      if (isGmsAvailable || Platform.isIOS) {
        try {
          const locationSettings = LocationSettings();

          final locationSubscription = Geolocator.getPositionStream(locationSettings: locationSettings)
              .handleError((e) {
                if (e is TimeoutException) {
                  logger.log('Geolocator stream timeout');
                } else {
                  logger.log('Geolocator stream error: $e');
                }
              })
              .listen((event) async {
                state = await _getLocation(event);
              });
          ref.onDispose(locationSubscription.cancel);

          return null;
        } catch (ex) {
          logger.log('Error listening to Geolocator stream: ${ex.toString()}');
        }
      } else if (isHMS) {
        try {
          final locationSubscription = CommonFunctions.listenToHMSStream()?.listen((event) async {
            state = await _getLocation(
              Position(
                longitude: event.longitude!,
                latitude: event.latitude!,
                timestamp: DateTime.now(),
                accuracy: event.horizontalAccuracyMeters ?? 0,
                altitude: event.altitude ?? 0,
                altitudeAccuracy: event.verticalAccuracyMeters ?? 0,
                heading: event.bearing ?? 0,
                headingAccuracy: event.bearingAccuracyDegrees ?? 0,
                speed: event.speed ?? 0,
                speedAccuracy: event.speedAccuracyMetersPerSecond ?? 0,
              ),
            );
          });
          if (locationSubscription != null) {
            ref.onDispose(locationSubscription.cancel);
          }
        } catch (ex) {
          logger.log('Error listening to HMS stream: ${ex.toString()}');
        }
      }
    });

    return null;
  }

  Future<bool> checkLocationPermission({String? routeOnClose, bool showGiveAccessSheet = true}) async {
    const routeLocation = '/request_location';
    final router = ref.read(appRouterProvider);
    final serviceStatus = await perm.Permission.location.serviceStatus;

    if (CommonFunctions.locationDialogShowed || router.isPathActive(routeLocation)) {
      return false;
    }
    try {
      if (serviceStatus != perm.ServiceStatus.disabled) {
        final status = await perm.Permission.location.request();
        if (status == perm.PermissionStatus.granted) {
          if (state == null) {
            final isGmsAvailable = await CommonFunctions.isGmsAvailable();
            final isHuawei = await CommonFunctions.isHuaweiDevice();
            Position? userLocation;

            if (isGmsAvailable || Platform.isIOS) {
              userLocation = await Geolocator.getLastKnownPosition();
            } else if (isHuawei) {
              userLocation = await CommonFunctions.getLastLocationHuawei();
            }
            state = await _getLocation(
              userLocation != null
                  ? Position(
                      latitude: userLocation.latitude,
                      longitude: userLocation.longitude,
                      timestamp: userLocation.timestamp,
                      accuracy: userLocation.accuracy,
                      altitude: userLocation.altitude,
                      altitudeAccuracy: userLocation.altitudeAccuracy,
                      heading: userLocation.heading,
                      headingAccuracy: userLocation.headingAccuracy,
                      speed: userLocation.speed,
                      speedAccuracy: userLocation.speedAccuracy,
                    )
                  : null,
            );
          }

          return true;
        } else {
          if (CommonFunctions.locationDialogShowed) {
            return false;
          }
          if (router.isPathActive(routeLocation)) {
            return false;
          }
          CommonFunctions.locationDialogShowed = true;

          unawaited(
            router
                .push(LocationErrorSheetRoute(routeOnClose: routeOnClose))
                .then((value) => CommonFunctions.locationDialogShowed = false),
          );
          return false;
        }
      } else {
        if (showGiveAccessSheet) {
          CommonFunctions.locationDialogShowed = true;

          unawaited(
            router
                .push(LocationErrorSheetRoute(routeOnClose: routeOnClose))
                .then((value) => CommonFunctions.locationDialogShowed = false),
          );
        }
      }
    } catch (ex) {
      logger.log('Error checking location permission: ${ex.toString()}');
    }

    return false;
  }

  Future<bool> checkOnLocationPermissionGranted() async {
    final status = await perm.Permission.location.status;

    if (status.isGranted) {
      final dgisController = await ref.read(dgisControllerProvider.future);
      unawaited(dgisController.onLocationPermissionGranted(desiredAccuracy: DesiredAccuracyMessage.high));

      CommonFunctions.locationDialogShowed = false;
      ref.invalidateSelf();
      return true;
    }

    state = null;
    return false;
  }

  Future<bool> checkLocationStatus() async {
    final status = await perm.Permission.location.status;

    return status.isGranted;
  }

  Future<void> refreshLocation() async {
    try {
      final status = await perm.Permission.location.status;
      if (!status.isGranted) {
        logger.log('Location permission not granted, cannot refresh');
        return;
      }

      final isGmsAvailable = await CommonFunctions.isGmsAvailable();
      final isHuawei = await CommonFunctions.isHuaweiDevice();
      Position? userLocation;

      if (isGmsAvailable) {
        userLocation = await Geolocator.getCurrentPosition();
      } else if (isHuawei) {
        userLocation = await CommonFunctions.getLastLocationHuawei();
      } else {
        // Fallback for simulator/devices without GMS or HMS - try Geolocator directly
        userLocation = await Geolocator.getCurrentPosition();
      }

      if (userLocation != null) {
        state = await _getLocation(userLocation);
      }
    } catch (ex) {
      logger.log('Error refreshing location: ${ex.toString()}');
    }
  }

  Future<Position?> _getLocation(Position? userLocation) async {
    // Use mocked location if user location is outside KSA
    if (userLocation == null) {
      return null;
    }
    final controller = await ref.read(dgisControllerProvider.future);
    final isLocationInsideKSA = await controller.contains(
      _saRect,
      GeoPointMessage(latitude: userLocation.latitude, longitude: userLocation.longitude),
    );
    return isLocationInsideKSA
        ? userLocation
        : Position(
            latitude: 24.712899222459676,
            longitude: 46.631036554650116,
            timestamp: userLocation.timestamp,
            accuracy: userLocation.accuracy,
            altitude: userLocation.altitude,
            altitudeAccuracy: userLocation.altitudeAccuracy,
            heading: userLocation.heading,
            headingAccuracy: userLocation.headingAccuracy,
            speed: userLocation.speed,
            speedAccuracy: userLocation.speedAccuracy,
          );
  }
}
