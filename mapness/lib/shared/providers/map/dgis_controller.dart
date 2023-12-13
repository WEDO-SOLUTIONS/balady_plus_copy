import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/_features/common/providers/permissions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'dgis_controller.g.dart';

final GeoPointMessage kingdomTower =
    GeoPointMessage(latitude: 24.712301, longitude: 46.674175);

GeoRectMessage saRect = GeoRectMessage(
  northEast: GeoPointMessage(latitude: 32.568765, longitude: 56.694472),
  southWest: GeoPointMessage(latitude: 15.506104, longitude: 32.61185),
);

// @Riverpod(keepAlive: true)
@riverpod
class DgisController extends _$DgisController {
  CameraPositionMessage? _lastCameraPosition;

  CameraPositionMessage? _lastRectPosition;

  late Completer<DgisMapController> _completer;

  late final StreamController<VisibleRectEvent> _visibleRectStream =
      StreamController.broadcast();
  Stream<VisibleRectEvent> get visibleRectEvents => _visibleRectStream.stream
      .debounceTime(const Duration(milliseconds: 5000));

  @override
  Future<DgisMapController> build() {
    _completer = Completer();

    ref.onDispose(() {
      _visibleRectStream.close();
    });

    return _completer.future;
  }

  Future<void> onMapCreated(DgisMapController controller) async {
    await initialize(controller);
    _completer.complete(controller);
  }

  Future<void> initialize(DgisMapController controller) async {
    PermissionStatus locationPermission = await ref.read(
      permissionsProvider(Permission.location).future,
    );
    final locationNotifier =
        ref.read(permissionsProvider(Permission.location).notifier);

    if (!locationPermission.isGranted) {
      locationPermission = await locationNotifier.request();
    }

    await controller.initialize();

    await controller.loadStyles("assets/maps/styles/common-styles.2gis");
    await controller.overrideLocales(
      ref.read(appLanguageProvider) == Language.arabic ? ["ar-SA"] : ["en-US"],
    );
    await controller.setAppearance(
      ref.read(darkModeProvider)
          ? MapAppearanceMessage.night
          : MapAppearanceMessage.day,
    );

    if (locationPermission.isGranted) {
      await controller.onLocationPremissionGranted(
        desiredAccuracy: DesiredAccuracyMessage.high,
      );
    } else {
      await controller.setCameraPosition(
        CameraPositionMessage(
          point: kingdomTower,
          zoom: 17,
          tilt: 45,
          bearing: 0,
        ),
      );
    }

    final visibleRectSubscription =
        controller.visibleRectEvents.listen(_visibleRectListener);
    final cameraPositionSubscription =
        controller.cameraPositionEvents.listen(_cameraPositionListener);

    ref.onDispose(
      () {
        visibleRectSubscription.cancel();
        cameraPositionSubscription.cancel();
      },
    );
    await controller.setZoomRestrictions(min: 5.5);
    Future.delayed(
      const Duration(milliseconds: 100),
      () => controller.changeFollowState(),
    );

    ref.listen(darkModeProvider, (previous, next) {
      controller.setAppearance(
        next ? MapAppearanceMessage.night : MapAppearanceMessage.day,
      );
    });
    ref.listen(appLanguageProvider, (previous, next) {
      controller.overrideLocales(
        next == Language.arabic ? ["ar-SA"] : ["en-US"],
      );
    });

    controller.installVoice("voice-sara");
    controller.installVoice("voice-jennifer");
  }

  void _visibleRectListener(VisibleRectEvent event) async {
    if ((!await state.value!
        .containsRect(saRect, event.visibleRect.geoRectMessage()))) {
      if (_lastRectPosition != null) {
        await state.value!.setCameraPosition(_lastRectPosition!);
      }
    } else {
      _lastRectPosition = _lastCameraPosition;
    }

    if (!_visibleRectStream.isClosed) {
      _visibleRectStream.sink.add(event);
    }
  }

  void _cameraPositionListener(CameraPositionMessage event) async {
    _lastCameraPosition = event;
  }
}
