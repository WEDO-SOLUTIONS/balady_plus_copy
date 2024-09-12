import 'dart:async';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:dgis_map/library.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';
import 'package:mapness/shared/ui/sheets/location_required_sheet.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location.g.dart';

final locationProvider = _locationProvider;

@Riverpod(keepAlive: true)
class _Location extends _$Location {
  @override
  Position? build() {
    checkLocationPermission().then((permitted) {
      if (!permitted) {
        return;
      }

      const locationSettings = LocationSettings();

      final locationSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (event) {
          state = event;
        },
      );
      ref.onDispose(locationSubscription.cancel);

      return null;
    });

    return null;
  }

  Future<bool> checkLocationPermission({String? routeOnClose}) async {
    const routeLocation = '/request_location';
    final serviceStatus = await perm.Permission.location.serviceStatus;
    final router = ref.read(goRouterProvider);

    if (serviceStatus != perm.ServiceStatus.disabled) {
      final status = await perm.Permission.location.request();

      if (status == perm.PermissionStatus.permanentlyDenied) {
        if (CommonFunctions.locationDialogShowed) {
          return false;
        }
        if (ref.read(currentRouteProvider)?.currentPath == routeLocation) {
          return false;
        }
        CommonFunctions.locationDialogShowed = true;

        unawaited(
          router
              .push(LocationErrorSheetRoute(routeOnClose: routeOnClose).location)
              .then((value) => CommonFunctions.locationDialogShowed = false),
        );
        return false;
      } else if (status != perm.PermissionStatus.granted) {
        unawaited(perm.Permission.location.request());
        return false;
      } else {
        if (state == null) {
          final position = await Geolocator.getLastKnownPosition();
          state = position;
        }

        return true;
      }
    } else {
      if (CommonFunctions.locationDialogShowed) {
        return false;
      }
      if (ref.read(currentRouteProvider)?.currentPath == routeLocation) {
        return false;
      }
      CommonFunctions.locationDialogShowed = true;

      unawaited(
        router
            .push(LocationErrorSheetRoute(routeOnClose: routeOnClose).location)
            .then((value) => CommonFunctions.locationDialogShowed = false),
      );
    }

    return false;
  }

  Future<bool> checkOnLocationPermissionGranted() async {
    final status = await perm.Permission.location.status;

    if (status.isGranted) {
      final dgisController = await ref.read(dgisControllerProvider.future);
      unawaited(
        dgisController.onLocationPermissionGranted(
          desiredAccuracy: DesiredAccuracyMessage.high,
        ),
      );
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
}
