import 'dart:async';

import 'package:dgis_map/library.dart' as sdk;
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/cityscape/cityscape_debug.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cityscape.g.dart';

/// Configuration for the Cityscape date range
class CityscapeConfig {
  /// Start date for the Cityscape
  static DateTime get startDate => DateTime(2025, 9, 18);

  /// End date for the Cityscape
  static DateTime get endDate => DateTime(2025, 9, 27, 23, 59, 59);

  /// Update interval for the provider (15 minutes)
  static const Duration updateInterval = Duration(minutes: 15);
}

/// Provider that checks if the current time is between two specified dates
/// and updates every 15 minutes.
///
/// Returns `true` if the current time is between the start and end dates,
/// `false` otherwise.
@riverpod
class Cityscape extends _$Cityscape {
  /// Object IDs for Riyadh International Convention & Exhibition Center
  static const int _cityscapeObjectId = 70030076677108076;

  // Riyadh International Convention & Exhibition Center,
  // Riyadh, Ar-Riyad, Riyadh, Saudi Arabia
  static final sdk.GeoPointMessage center = sdk.GeoPointMessage(
    latitude: 25.252325164174778,
    longitude: 46.38741921633482,
  );

  static const String cityscapeGlobalMarkerId = 'cityscape_global';

  MapObjectManager? mapManager;

  String get customPinPath => Assets.icons.svg.icCityscapePin.keyName;

  String get customMarker => Assets.icons.svg.cityscapeUniqueMarker.keyName;

  String get globalImg => Assets.images.cityscapeGlobal.keyName;

  @override
  bool build() {
    // Check if debug override is enabled
    final debugOverride = ref.watch(cityscapeDebugProvider);
    if (debugOverride) {
      return true;
    }

    // Return the initial state
    return _isCurrentTimeInRange();
  }

  /// Checks if the current time is within the specified date range
  bool _isCurrentTimeInRange() {
    final now = DateTime.now();
    return now.isAfter(CityscapeConfig.startDate) && now.isBefore(CityscapeConfig.endDate);
  }

  /// Checks if the custom pin should be shown, based on the object ID
  bool showCustomPin(int objectId) => _cityscapeObjectId == objectId && state;

  /// Manually triggers an update of the state
  void refresh() {
    state = _isCurrentTimeInRange();
  }

  Future<void> initializeGlobalMarker() async {
    mapManager = ref.read(
      mapObjectManagerProvider(
        named: MapObjectManagerSettings.myLocation().name,
        layerId: MapObjectManagerSettings.myLocation().layerId,
      ).notifier,
    );
    await mapManager?.removeMarkerById(cityscapeGlobalMarkerId);

    final globalMarker = sdk.Marker(
      id: cityscapeGlobalMarkerId,
      options: sdk.MarkerOptionsMessage(
        position: sdk.GeoPointWithElevationMessage(
          latitude: 25.252325164174778,
          longitude: 46.38741921633482,
          elevation: 1,
        ),
        icon: sdk.MarkerIconMessage(svgPath: customPinPath, width: 70),
        anchor: sdk.MarkerAnchorMessage(x: 0.5, y: 1),
        animatedAppearance: true,
        isVisible: false,
        zIndex: 50,
      ),
      onTap: openThePlace,
    );

    await mapManager?.addMarker(globalMarker);
  }

  Future<void> showGlobalMarker() async {
    await mapManager?.setMarkerOptions(
      cityscapeGlobalMarkerId,
      sdk.ChangeMarkerOptionsMessage(
        position: sdk.GeoPointWithElevationMessage(
          latitude: 25.252325164174778,
          longitude: 46.38741921633482,
          elevation: 1,
        ),
        icon: sdk.MarkerIconMessage(svgPath: customPinPath, width: 70),
        anchor: sdk.MarkerAnchorMessage(x: 0, y: 0),
        animatedAppearance: true,
        isVisible: true,
        zIndex: 50,
      ),
    );
  }

  Future<void> hideGlobalMarker() async {
    await mapManager?.setMarkerOptions(cityscapeGlobalMarkerId, sdk.ChangeMarkerOptionsMessage(isVisible: false));
  }

  void openThePlace() {
    unawaited(
      ref.read(cameraPositionProvider.notifier).animateTo(
            sdk.CameraPositionMessage(
              point: center,
              zoom: 18.0,
              tilt: 0.0,
              bearing: 0.0,
            ),
          ),
    );

    unawaited(
      ref.watch(
        pointOfInterestProvider(
          sdk.DgisObjectIdMessage(objectId: _cityscapeObjectId, entranceId: 0),
          sdk.LatLng(latitude: center.latitude, longitude: center.longitude),
        ).future,
      ),
    );
  }

  /// Simple provider that returns the current status without periodic updates
  /// Use this if you only need a one-time check
  static bool isNow() {
    // Check if debug override is enabled
    if (cityscapeDebugOverride) {
      return true;
    }

    final now = DateTime.now();
    return now.isAfter(CityscapeConfig.startDate) && now.isBefore(CityscapeConfig.endDate);
  }

  /// Provider that returns the remaining time until Saudi National Day
  /// Returns null if the date has passed or is not this year
  static Duration? countdown() {
    final now = DateTime.now();
    return countdownFromDate(now);
  }

  static Duration? countdownFromDate(DateTime now) {
    // If debug override is enabled, return null (no countdown needed)
    if (cityscapeDebugOverride) {
      return null;
    }

    // If we're past the current year's date, return null
    if (now.isAfter(CityscapeConfig.startDate)) {
      return null;
    }

    return CityscapeConfig.startDate.difference(now);
  }
}
