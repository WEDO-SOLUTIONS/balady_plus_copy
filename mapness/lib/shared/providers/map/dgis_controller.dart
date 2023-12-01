import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/_features/common/providers/permissions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dgis_controller.g.dart';

final GeoPointMessage kingdomTower =
    GeoPointMessage(latitude: 24.712301, longitude: 46.674175);

GeoRectMessage saRect = GeoRectMessage(
  northEast: GeoPointMessage(latitude: 32.568765, longitude: 56.694472),
  southWest: GeoPointMessage(latitude: 15.506104, longitude: 32.61185),
);

@riverpod
class DgisController extends _$DgisController {
  CameraPositionMessage? _lastCameraPosition;

  CameraPositionMessage? _lastRectPosition;

  @override
  DgisMapController? build() => null;

  Future<void> onMapCreated(DgisMapController controller) async {
    await initialize(controller);
    state = controller;
  }

  Future<void> initialize(DgisMapController controller) async {
    PermissionStatus locationPermission = await ref.watch(
      permissionsProvider(Permission.location).future,
    );
    final locationNotifier =
        ref.watch(permissionsProvider(Permission.location).notifier);

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

    ref.onDispose(
      () {},
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
  }

  void _visibleRectListener(VisibleRectEvent event) async {
    if (state == null) return;

    if ((!await state!
        .containsRect(saRect, event.visibleRect.geoRectMessage()))) {
      if (_lastRectPosition != null) {
        await state!.setCameraPosition(_lastRectPosition!);
      }
    } else {
      _lastRectPosition = _lastCameraPosition;
    }
  }

  void _cameraPositionListener(CameraPositionMessage event) async {
    _lastCameraPosition = event;
  }
}
