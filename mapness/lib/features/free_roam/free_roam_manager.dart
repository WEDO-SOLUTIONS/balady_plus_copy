import 'dart:convert';

import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/navigator_voice.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'free_roam_manager.g.dart';

const _navigatorOn = 'navigatorOn';

@riverpod
class _FreeRoamManager extends _$FreeRoamManager {
  @override
  void build() {}

  Future<void> initFreeRoam() async {
    final dgisController = await ref.read(dgisControllerProvider.future);

    await dgisController.setNavigatorVoice(ref.read(navigatorVoiceProvider));

    await dgisController.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.85));

    await dgisController.freeRoamController.start(
      SpeedRangeZoom(
        maxSpeedRange: 5,
        minSpeedRange: 0,
        routeDistanceMillimeters: 0,
        styleZoomValue: 16.5,
      ),
    );
    await dgisController.setMapAttributeBool(_navigatorOn, value: true);
    await dgisController.followNavigation();
  }

  Future<void> restoreNavigationState(void Function() onError) async {
    final dgisController = await ref.read(dgisControllerProvider.future);

    final state = base64.decode(
      ref.read(sharedPrefsProvider).getString(MapnessConstants.navigatorStateKey)!,
    );
    try {
      await dgisController.restoreNavigationState(
        state,
        SpeedRangeZoom(
          maxSpeedRange: 5,
          minSpeedRange: 0,
          routeDistanceMillimeters: 0,
          styleZoomValue: 16.5,
        ),
      );
    } catch (e) {
      onError();
    }
  }

  // Show the home page after the trip is finished
  Future<void> endTripAndShowHome({required BuildContext context}) async {
    final dgisController = ref.read(dgisControllerProvider);
    Metrics.logEventAdvanced(
      MetricsConstants.navigationKeys.endTripAndShowHome,
      group: MetricsConstants.navigationTag,
      action: MetricAction.tap.toString(),
    );
    await ref.read(urbiAnalyticsProvider).track(MapnessConstants.analyticsTripStopped);
    await dgisController.value?.freeRoamController.stop();
    await dgisController.value?.setMapAttributeBool(_navigatorOn, value: false);
    await _parkingCheck();
    if (context.mounted) {
      const LandingRoute().go(context);
    }
  }

  /// If I enable parking during [FreeRoam], after the check is completed they are hidden if hidden from [Layers].
  /// If it is enabled in [Layers], then if I disable it in [FreeRoam], then after completion they are also disabled
  Future<void> _parkingCheck() async {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final isParkingEnabledByFreeRoam = sharedPrefs.getBool(MapnessConstants.parkingEnabledFreeRoam) ?? false;

    if (isParkingEnabledByFreeRoam) {
      final layersNotifier = ref.read(layersControlsProvider.notifier);
      await layersNotifier.toggleParking();
      await sharedPrefs.setBool(MapnessConstants.parkingEnabledFreeRoam, false);
    }
  }

  void deactivate() {
    ref.read(dgisControllerProvider).value?.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.5));
    ref.read(dgisControllerProvider).value?.toggleFollowState();
  }
}

final freeRoamManagerProvider = _freeRoamManagerProvider;
