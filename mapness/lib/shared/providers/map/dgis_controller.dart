import 'dart:async';
import 'dart:math';

import 'package:dgis_map/library.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/features/dynamic_style/map_style_store.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/map_recreation.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/utils/location_setup_helper.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'dgis_controller.g.dart';

final GeoPointMessage _kingdomTower = GeoPointMessage(latitude: 24.712301, longitude: 46.674175);
const double _indoorFloorPlansMinZoom = 19;

/// Plain top-level reference to the live [DgisMapController].
///
/// this exists so consumers like `locationProvider` can read the
/// controller without registering a Riverpod dependency edge. Previously
/// `locationProvider` used `ref.listen(dgisControllerProvider, ...)`, but
/// `dgisControllerProvider` itself depends on `darkModeProvider →
/// LocationWithPrecision → locationProvider` during its own build, so any
/// reverse Riverpod edge from `locationProvider` back to
/// `dgisControllerProvider` closes a graph cycle and trips
/// `CircularDependencyError`. A plain mutable variable is invisible to
/// Riverpod's graph analysis, so reads from it never trip the check.
///
/// Set in [DgisController.onMapCreated] (as soon as the native map is ready)
/// and cleared in build's onDispose.
DgisMapController? activeDgisController;

@Riverpod(keepAlive: true)
class DgisController extends _$DgisController {
  late Completer<DgisMapController> _completer;
  late LocationSetupHelper _locationHelper;
  // Non-final so build() can replace it with a fresh open subject on each rebuild.
  BehaviorSubject<VisibleRectEvent?> _visibleRectSubject = BehaviorSubject<VisibleRectEvent?>();
  bool? _indoorFloorPlansEnabled;
  StreamSubscription<Position>? _firstFixSubscription;
  bool _startupRecenterSuppressed = false;

  /// True once [cancelFirstFixCameraMove] has run, i.e. something moved the
  /// camera explicitly (e.g. a cold-start POI deep link). Startup-time
  /// recentering logic (first-GPS-fix snap, MapDimensionsControl's initial 3D
  /// tilt) must check this and stand down instead of yanking the camera away
  /// from the explicit target.
  bool get startupRecenterSuppressed => _startupRecenterSuppressed;

  ValueStream<VisibleRectEvent?> get visibleRectSubject => _visibleRectSubject;

  @override
  Future<DgisMapController> build() {
    _completer = Completer();
    _visibleRectSubject = BehaviorSubject<VisibleRectEvent?>();
    // onDispose below calls cancelFirstFixCameraMove, which raises the flag;
    // a rebuilt map starts a fresh startup sequence.
    _startupRecenterSuppressed = false;

    // clear the top-level cache when this provider is disposed
    // so stale references can't be observed across re-creation.
    ref
      ..onDispose(_visibleRectSubject.close)
      ..onDispose(() {
        activeDgisController = null;
      })
      ..onDispose(cancelFirstFixCameraMove);

    return _completer.future;
  }

  Future<void> onMapCreated(DgisMapController controller) async {
    // publish the controller to the top-level cache *before*
    // running the long async _initialize chain. _initialize awaits
    // darkModeProvider, which in turn awaits locationProvider, and the
    // Geolocator stream listener inside locationProvider needs to read this
    // controller without going through Riverpod (any Riverpod read would
    // close a graph cycle — see [activeDgisController] doc).
    activeDgisController = controller;
    await _initialize(controller);
    if (!_completer.isCompleted) {
      _completer.complete(controller);
    }
  }

  Future<void> _initialize(DgisMapController controller) async {
    await _setupControllerItself(controller);
    await _setupLocation(controller);
    await _restorePendingCamera(controller);
    await _setupVisibleRectUpdates(controller);
  }

  /// Applies a camera position stashed by [PendingCameraSnapshot] before a
  /// MapView recreate (e.g. car-model swap). Called after the style loads and
  /// the default-location intro finishes, so the user lands back where they
  /// were rather than at the Kingdom Tower fallback. No-op when nothing is
  /// pending.
  Future<void> _restorePendingCamera(DgisMapController controller) async {
    final pending = ref.read(pendingCameraSnapshotProvider);
    if (pending == null) {
      return;
    }
    ref.read(pendingCameraSnapshotProvider.notifier).clear();
    try {
      await controller.setCameraPosition(pending);
      logger.log('[dgis_controller] restored pending camera after MapView recreate');
    } on PlatformException catch (e) {
      logger.log(
        '[dgis_controller] failed to restore pending camera: $e',
        logLevel: MapnessLogLevel.warning,
      );
    }
  }

  Future<void> _setupControllerItself(DgisMapController controller) async {
    await controller.initialize();

    await _loadActiveStyle(controller);

    // React to store revision bumps at runtime — repack / network / picker
    // mutations all overwrite the same canonical file in place, so all we
    // need to do here is re-run loadStylesFromPath on the (unchanged) path.
    ref.listen<AsyncValue<StyleFile>>(mapStyleStoreProvider, (previous, next) {
      final prevRev = previous?.value?.revision;
      final nextFile = next.value;
      if (nextFile == null || prevRev == nextFile.revision) {
        return;
      }
      unawaited(_loadStyle(controller, nextFile.path));
    });

    // Appearance
    await controller.setZoomRestrictions(min: 5.5);
    await controller.setIndoorFloorPlansEnabled(enabled: false);
    _indoorFloorPlansEnabled = false;
    await controller.overrideLocales(ref.read(appLanguageProvider) == Language.arabic ? ['ar-SA'] : ['en-SA']);
    await controller.setAppearance(
      (await ref.read(darkModeProvider.future)).isDark ? MapAppearanceMessage.night : MapAppearanceMessage.day,
    );
    ref
      ..listen(darkModeProvider, (previous, next) {
        controller.setAppearance(next.value?.isDark ?? false ? MapAppearanceMessage.night : MapAppearanceMessage.day);
      })
      ..listen(appLanguageProvider, (previous, next) {
        controller.overrideLocales(next == Language.arabic ? ['ar-SA'] : ['en-SA']);
      });

    await controller.setBetterRouteSettings(BetterRouteSettings.prod);

    try {
      // Voice
      await controller.installVoice('voice-saud');
    } on PlatformException catch (e) {
      logger.log('Voice installation error: $e');
    }
  }

  Future<void> _loadActiveStyle(DgisMapController controller) async {
    final styleFile = await ref.read(mapStyleStoreProvider.future);
    await _loadStyle(controller, styleFile.path);
  }

  Future<void> _loadStyle(DgisMapController controller, String absolutePath) async {
    final sw = Stopwatch()..start();
    try {
      logger.log('[dynamic_style] loadStyle: loadStylesFromPath($absolutePath)');
      await controller.loadStylesFromPath(absolutePath);
      logger.log('[dynamic_style] loadStyle: applied in ${sw.elapsedMilliseconds}ms');
    } on PlatformException catch (e) {
      // If the canonical file is corrupt or missing, fall back to the
      // bundled asset via the legacy loadStyles() path. This keeps the map
      // functional; a subsequent app restart will let the store re-copy.
      logger
        ..log(
          '[dynamic_style] loadStyle: FAILED $absolutePath after ${sw.elapsedMilliseconds}ms: $e',
          logLevel: MapnessLogLevel.error,
        )
        ..log('[dynamic_style] loadStyle: falling back to bundled asset ${MapnessConstants.mapStylesPath}');
      await controller.loadStyles(MapnessConstants.mapStylesPath);
    }
  }

  Future<void> _setupLocation(DgisMapController controller) async {
    // When a MapView recreate is in flight (e.g. car-model swap), the user
    // already had a camera position we're about to restore in
    // [_restorePendingCamera]. Skip the Kingdom Tower intro and the
    // first-fix snap so we don't overwrite the restored position.
    final hasPendingCamera = ref.read(pendingCameraSnapshotProvider) != null;
    if (!hasPendingCamera) {
      await _setDefaultLocation(controller);
    }

    _locationHelper = LocationSetupHelper(controller);
    await _locationHelper.run();
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      await controller.onLocationPermissionGranted(desiredAccuracy: DesiredAccuracyMessage.high);
    }
    await controller.toggleFollowState();
    if (!hasPendingCamera) {
      _moveToUserLocationOnFirstFix(controller);
    }
  }

  /// After the Kingdom Tower intro animation, waits for the first real GPS fix
  /// and snaps the camera there so the user sees their actual position.
  ///
  /// Cancelled by [cancelFirstFixCameraMove] when something moves the camera
  /// deliberately in the meantime (e.g. a cold-start POI deep link): on Android
  /// the first fix can arrive seconds after launch and would otherwise yank the
  /// camera away from the deep-linked POI.
  void _moveToUserLocationOnFirstFix(DgisMapController controller) {
    _firstFixSubscription = Geolocator.getPositionStream(locationSettings: const LocationSettings())
        .take(1)
        .listen(
          (position) => controller.setCameraPosition(
            CameraPositionMessage(
              point: GeoPointMessage(latitude: position.latitude, longitude: position.longitude),
              zoom: 17,
              tilt: 0,
              bearing: 0,
            ),
          ),
          onError: (Object e) => logger.log('First GPS fix error: $e'),
          cancelOnError: true,
        );
  }

  /// Prevents the pending first-GPS-fix snap (and, via
  /// [startupRecenterSuppressed], any other startup recentering) from
  /// overriding an explicit camera move. Safe to call at any time, including
  /// before the map is ready.
  void cancelFirstFixCameraMove() {
    _startupRecenterSuppressed = true;
    _firstFixSubscription?.cancel();
    _firstFixSubscription = null;
  }

  /// Moves camera on Riyadh Tower
  Future<void> _setDefaultLocation(DgisMapController controller) async {
    await controller.setCameraPosition(CameraPositionMessage(point: _kingdomTower, zoom: 17, tilt: 0, bearing: 0));
    await controller.moveCamera(
      CameraPositionMessage(
        point: getForwardPosition(_kingdomTower, 0),
        zoom: 17,
        tilt: 65,
        bearing: 0,
      ),
      0.3,
      CameraAnimationTypeMessage.linear,
    );
  }

  GeoPointMessage getForwardPosition(GeoPointMessage position, double bearing) {
    const forward = 0.0005;
    const side = 0.0002;

    final forwardLat = forward * cos(bearing * pi / 180);
    final forwardLng = forward * sin(bearing * pi / 180);

    final sideAngle = (bearing - 90) * pi / 180;
    final sideLat = side * cos(sideAngle);
    final sideLng = side * sin(sideAngle);

    final lat = position.latitude + forwardLat + sideLat;
    final lng = position.longitude + forwardLng + sideLng;

    return GeoPointMessage(latitude: lat, longitude: lng);
  }

  Future<PolygonGeometryMessage> getVisibleArea(DgisMapController controller) async => controller.getVisibleArea();

  Future<void> _setupVisibleRectUpdates(DgisMapController controller) async {
    final visibleRectSubscription = controller.visibleRectEvents
        .debounceTime(const Duration(seconds: 1))
        .listen((event) => _listenVisibleRectangle(controller, event));
    _visibleRectSubject.add(null);

    ref.onDispose(visibleRectSubscription.cancel);
  }

  void _listenVisibleRectangle(DgisMapController controller, VisibleRectEvent event) {
    ref.read(urbiAnalyticsProvider).track('mapInteraction');
    _syncIndoorFloorPlansWithZoom(controller, event.visibleRect.zoom);
    if (!_visibleRectSubject.isClosed) {
      _visibleRectSubject.add(event);
    }
  }

  void _syncIndoorFloorPlansWithZoom(DgisMapController controller, double zoom) {
    final enabled = zoom >= _indoorFloorPlansMinZoom;
    if (_indoorFloorPlansEnabled == enabled) {
      return;
    }

    _indoorFloorPlansEnabled = enabled;
    unawaited(controller.setIndoorFloorPlansEnabled(enabled: enabled));
  }
}
