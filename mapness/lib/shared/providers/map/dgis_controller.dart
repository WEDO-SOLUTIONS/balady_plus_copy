import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/utils/location_setup_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'dgis_controller.g.dart';

final GeoPointMessage _kingdomTower = GeoPointMessage(latitude: 24.712301, longitude: 46.674175);

@Riverpod(keepAlive: true)
class DgisController extends _$DgisController {
  late Completer<DgisMapController> _completer;
  late LocationSetupHelper locationHelper;
  final _visibleRectSubject = BehaviorSubject<VisibleRectEvent?>();

  ValueStream<VisibleRectEvent?> get visibleRectSubject => _visibleRectSubject;

  @override
  Future<DgisMapController> build() {
    _completer = Completer();

    ref.onDispose(_visibleRectSubject.close);

    return _completer.future;
  }

  Future<void> onMapCreated(DgisMapController controller) async {
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

    // Styles
    await controller.loadStyles(MapnessConstants.mapStylesPath);

    // Appearance
    await controller.setZoomRestrictions(
      min: 5.5,
    );
    await controller.overrideLocales(
      ref.read(appLanguageProvider) == Language.arabic ? ['ar-SA'] : ['en-SA'],
    );
    await controller.setAppearance(
      (await ref.read(darkModeProvider.future)).isDark ? MapAppearanceMessage.night : MapAppearanceMessage.day,
    );
    ref
      ..listen(
        darkModeProvider,
        (previous, next) {
          controller.setAppearance(
            next.valueOrNull?.isDark ?? false ? MapAppearanceMessage.night : MapAppearanceMessage.day,
          );
        },
      )
      ..listen(
        appLanguageProvider,
        (previous, next) {
          controller.overrideLocales(
            next == Language.arabic ? ['ar-SA'] : ['en-SA'],
          );
        },
      );

    await controller.setBetterRouteSettings(BetterRouteSettings.prod);

    try {
      // Voice
      await controller.installVoice('voice-saud');
    } on PlatformException catch (e) {
      debugPrint('Voice installation error: $e');
    }
  }

  Future<void> _setupLocation(DgisMapController controller) async {
    await _setDefaultLocation(controller);

    locationHelper = LocationSetupHelper(controller);
    await locationHelper.run();

    // at this point, geolocation is either activated,
    // or the user has definitively denied it (the helper will timeout
    // if you add it inside _LocationSetupHelper).
  }

  /// Moves camera on Riyadh Tower
  Future<void> _setDefaultLocation(DgisMapController controller) async {
    await controller.setCameraPosition(
      CameraPositionMessage(
        point: _kingdomTower,
        zoom: 17,
        tilt: 0,
        bearing: 0,
      ),
    );
  }

  Future<PolygonGeometryMessage> getVisibleArea(DgisMapController controller) async => controller.getVisibleArea();

  Future<void> _setupVisibleRectUpdates(DgisMapController controller) async {
    final visibleRectSubscription =
        controller.visibleRectEvents.debounceTime(const Duration(seconds: 1)).listen(_listenVisibleRectangle);
    _visibleRectSubject.add(null);

    ref.onDispose(visibleRectSubscription.cancel);
  }

  void _listenVisibleRectangle(VisibleRectEvent event) {
    ref.read(urbiAnalyticsProvider).track(
          'mapInteraction',
        );
    if (!_visibleRectSubject.isClosed) {
      _visibleRectSubject.add(event);
    }
  }
}
