import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter_insider/flutter_insider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/city_contain/dto/location_point.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location.g.dart';

final locationProvider = _locationProvider;

/// Location settings for the app's own position stream.
///
/// geolocator already enables background updates by default on iOS; what it
/// does not do is show the status bar indicator, and without it a session that
/// keeps running with the screen locked is invisible to the user. The engine's
/// own source is fixed natively — see BackgroundLocationProvider in dgis_map.
LocationSettings _backgroundLocationSettings() {
  if (Platform.isIOS) {
    return AppleSettings(showBackgroundLocationIndicator: true);
  }
  return const LocationSettings();
}

bool _insiderGeofenceStarted = false;

/// WARNING: the returned [Position] is always an object not equal to the previous one because it has [timestamp]
/// field. You might need to [select()] from this provider only when lat and long have really changed
@Riverpod(keepAlive: true)
class _Location extends _$Location {
  final _saRect = GeoRectMessage(
    northEast: GeoPointMessage(latitude: 32.568765, longitude: 56.694472),
    southWest: GeoPointMessage(latitude: 15.506104, longitude: 32.61185),
  );

  @override
  Position? build() {
    // do NOT register any Riverpod edge to dgisControllerProvider
    // here. `dgisControllerProvider` depends on darkModeProvider → ... →
    // locationProvider during its own build, so any reverse `ref.watch` /
    // `ref.listen` / `ref.read` from this provider back to
    // dgisControllerProvider closes a graph cycle. The Geolocator stream
    // listener and other async callsites read the controller from the plain
    // top-level [activeDgisController] cache (populated by
    // DgisController.onMapCreated) — invisible to Riverpod's graph analysis.
    checkLocationPermission(showGiveAccessSheet: false, restartPipelineIfInactive: false).then((permitted) async {
      if (!ref.mounted || !permitted) {
        return;
      }
      final isGmsAvailable = await CommonFunctions.isGmsAvailable();
      final isHMS = await CommonFunctions.isHuaweiDevice();
      if (!ref.mounted) {
        return;
      }

      // gms is not available on iOS so we use the standard library in the case
      if (isGmsAvailable || Platform.isIOS) {
        try {
          final locationSettings = _backgroundLocationSettings();

          final locationSubscription = Geolocator.getPositionStream(locationSettings: locationSettings)
              .handleError((e) {
                if (e is TimeoutException) {
                  logger.log('Geolocator stream timeout');
                } else {
                  logger.log('Geolocator stream error: $e');
                }
              })
              .listen((event) async {
                final location = await _getLocation(event);
                if (!ref.mounted) {
                  return;
                }
                state = location;
              });
          ref.onDispose(locationSubscription.cancel);

          return null;
        } catch (ex) {
          logger.log('Error listening to Geolocator stream: ${ex.toString()}');
        }
      } else if (isHMS) {
        try {
          final locationSubscription = CommonFunctions.listenToHMSStream()?.listen((event) async {
            final location = await _getLocation(
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
            if (!ref.mounted) {
              return;
            }
            state = location;
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

  Future<void> _startInsiderGeofenceIfNeeded() async {
    if (_insiderGeofenceStarted) {
      return;
    }
    _insiderGeofenceStarted = true;

    // IMPORTANT:
    // permission_handler "location" == whileInUse on iOS.
    // For geofence background you need ALWAYS.
    // So we verify with Geolocator's permission state:
    final geoPerm = await Geolocator.checkPermission();
    if (geoPerm != LocationPermission.always) {
      _insiderGeofenceStarted = false; // allow retry later if user upgrades to Always
      return;
    }

    await FlutterInsider.Instance.enableLocationCollection(true);

    if (Platform.isIOS) {
      await FlutterInsider.Instance.setAllowsBackgroundLocationUpdates(true);
    }

    await FlutterInsider.Instance.startTrackingGeofence();
  }

  Future<bool> checkLocationPermission({
    String? routeOnClose,
    bool showGiveAccessSheet = true,
    bool restartPipelineIfInactive = true,
  }) async {
    const routeLocation = '/request_location';
    final router = ref.read(appRouterProvider);
    final serviceStatus = await perm.Permission.location.serviceStatus;
    if (!ref.mounted) {
      return false;
    }

    if (CommonFunctions.locationDialogShowed || router.isPathActive(routeLocation)) {
      return false;
    }
    try {
      if (serviceStatus != perm.ServiceStatus.disabled) {
        final status = await perm.Permission.location.request();
        if (!ref.mounted) {
          return false;
        }
        if (status == perm.PermissionStatus.granted) {
          unawaited(_startInsiderGeofenceIfNeeded());
          final pipelineWasInactive = state == null;
          if (state == null) {
            final isGmsAvailable = await CommonFunctions.isGmsAvailable();
            final isHuawei = await CommonFunctions.isHuaweiDevice();
            if (!ref.mounted) {
              return false;
            }
            Position? userLocation;

            if (isGmsAvailable || Platform.isIOS) {
              userLocation = await Geolocator.getLastKnownPosition();
            } else if (isHuawei) {
              userLocation = await CommonFunctions.getLastLocationHuawei();
            }
            final location = await _getLocation(
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
            if (!ref.mounted) {
              return false;
            }
            state = location;
          }
          if (restartPipelineIfInactive && pipelineWasInactive) {
            final DgisMapController? controller = activeDgisController ?? await ref.read(dgisControllerProvider.future);
            if (!ref.mounted) {
              return false;
            }
            if (controller != null) {
              unawaited(controller.onLocationPermissionGranted(desiredAccuracy: DesiredAccuracyMessage.high));
            }
            ref.invalidateSelf();
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
      // prefer the top-level [activeDgisController] cache so we
      // don't go through Riverpod (which would close the graph cycle —
      // dgisControllerProvider transitively depends on locationProvider).
      // Fall back to `ref.read(dgisControllerProvider.future)` only if the
      // cache is empty; in that case we're by definition outside the
      // initialization window where the cycle could trip.
      final DgisMapController dgisController = activeDgisController ?? await ref.read(dgisControllerProvider.future);
      if (!ref.mounted) {
        return false;
      }
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
      if (!ref.mounted) {
        return;
      }
      if (!status.isGranted) {
        logger.log('Location permission not granted, cannot refresh');
        return;
      }

      final isGmsAvailable = await CommonFunctions.isGmsAvailable();
      final isHuawei = await CommonFunctions.isHuaweiDevice();
      if (!ref.mounted) {
        return;
      }
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
        final location = await _getLocation(userLocation);
        if (!ref.mounted) {
          return;
        }
        state = location;
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

    // read the controller from the plain top-level cache
    // [activeDgisController]. We can't use `ref.read(dgisControllerProvider)`
    // because dgisControllerProvider transitively depends on this provider
    // (via darkModeProvider → LocationWithPrecision → us) and any reverse
    // Riverpod read closes a graph cycle. See [activeDgisController] doc.
    final controller = activeDgisController;
    if (controller == null) {
      return userLocation;
    }

    final isLocationInsideKSA = await controller.contains(
      _saRect,
      GeoPointMessage(latitude: userLocation.latitude, longitude: userLocation.longitude),
    );
    if (!ref.mounted) {
      return null;
    }
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

/// This provider wraps basic [locationProvider] and rebuilds only when the value specified precision has actually changed
/// DECIMAL PLACES   METERS
/// 0                111 120
/// 1                11 112
/// 2                1 111.2
/// 3                111.12
/// 4                11.112
/// 5                1.1112
/// 6                0.11112
/// 7                0.01111
@riverpod
class LocationWithPrecision extends _$LocationWithPrecision {
  @override
  LocationPoint? build({required int decimalPlaces}) {
    final location = ref.watch(locationProvider);
    if (location == null) {
      return null;
    }

    return LocationPoint(
      latitude: _roundToPrecision(location.latitude, decimalPlaces),
      longitude: _roundToPrecision(location.longitude, decimalPlaces),
    );
  }

  double _roundToPrecision(double value, int decimalPlaces) {
    final mod = pow(10, decimalPlaces).toDouble();
    return (value * mod).round() / mod;
  }
}

/// this provider waits for first non-null location or throws after timeout
@riverpod
Future<Position> getLocationSync(Ref ref, {Duration timeoutAfter = const Duration(seconds: 5)}) async {
  final location = ref.read(locationProvider);
  if (location != null) {
    return location;
  } else {
    final completer = Completer<Position>();

    final sub = ref.listen<Position?>(locationProvider, (_, next) {
      if (next != null) {
        completer.complete(next);
      }
    });

    return completer.future.timeout(timeoutAfter).whenComplete(sub.close);
  }
}
