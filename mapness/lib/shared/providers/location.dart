import 'dart:async';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:dgis_map/library.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/shared/ui/sheets/location_required_sheet.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location.g.dart';

final locationProvider = _locationProvider;

@Riverpod(keepAlive: true)
class _Location extends _$Location {
  @override
  GeoPointMessage? build() {
    checkLocationPermission().then((permitted) {
      if (!permitted) {
        return;
      }

      const locationSettings = LocationSettings();

      final locationSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (event) {
          state = GeoPointMessage(
            latitude: event.latitude,
            longitude: event.longitude,
          );
        },
      );
      ref.onDispose(locationSubscription.cancel);

      return null;
    });

    return null;
  }

  Future<bool> checkLocationPermission({String? routeOnClose}) async {
    final serviceStatus = await perm.Permission.location.serviceStatus;
    final router = ref.read(goRouterProvider);

    if (serviceStatus != perm.ServiceStatus.disabled) {
      final status = await perm.Permission.location.request();

      if (status == perm.PermissionStatus.permanentlyDenied) {
        if (!CommonFunctions.locationDialogShowed) {
          CommonFunctions.locationDialogShowed = true;
          unawaited(
            router
                .push(LocationErrorSheet(routeOnClose: routeOnClose).location)
                .then((value) => CommonFunctions.locationDialogShowed = false),
          );
        }
        return false;
      } else if (status != perm.PermissionStatus.granted) {
        unawaited(perm.Permission.location.request());
        return false;
      } else {
        return true;
      }
    } else {
      if (!CommonFunctions.locationDialogShowed) {
        CommonFunctions.locationDialogShowed = true;
        unawaited(
          router
              .push(LocationErrorSheet(routeOnClose: routeOnClose).location)
              .then((value) => CommonFunctions.locationDialogShowed = true),
        );
      }
    }

    return false;
  }
}
