import 'dart:async';
import 'dart:math';

import 'package:dgis_map/library.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
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

  ValueStream<VisibleRectEvent?> get visibleRectSubject => _visibleRectSubject;

  @override
  Future<DgisMapController> build() {
    _completer = Completer();
    _visibleRectSubject = BehaviorSubject<VisibleRectEvent?>();

    // clear the top-level cache when this provider is disposed
    // so stale references can't be observed across re-creation.
    ref
      ..onDispose(_visibleRectSubject.close)
      ..onDispose(() {
        activeDgisController = null;
      });

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
    await _setupVisibleRectUpdates(controller);
  }

  Future<void> _setupControllerItself(DgisMapController controller) async {
    await controller.initialize();

    await controller.loadStyles(MapnessConstants.mapStylesPath);

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

  Future<void> _setupLocation(DgisMapController controller) async {
    await _setDefaultLocation(controller);

    _locationHelper = LocationSetupHelper(controller);
    await _locationHelper.run();
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      await controller.onLocationPermissionGranted(desiredAccuracy: DesiredAccuracyMessage.high);
    }
    await controller.toggleFollowState();
    _moveToUserLocationOnFirstFix(controller);
  }

  /// After the Kingdom Tower intro animation, waits for the first real GPS fix
  /// and snaps the camera there so the user sees their actual position.
  void _moveToUserLocationOnFirstFix(DgisMapController controller) {
    Geolocator.getPositionStream(locationSettings: const LocationSettings())
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
