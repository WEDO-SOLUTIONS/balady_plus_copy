import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/lifestyle_layers/providers/active_layer.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/navigation_constants.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/navigator_voice.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'free_roam_manager.g.dart';

const _navigatorOn = 'navigatorOn';

@Riverpod(keepAlive: true)
class _FreeRoamManager extends _$FreeRoamManager {
  @override
  void build() {}

  Future<void> initFreeRoam() async {
    final dgisController = await ref.read(dgisControllerProvider.future);

    await dgisController.setNavigatorVoice(ref.read(navigatorVoiceProvider));

    await dgisController.freeRoamController.start(
      NavigationConstants.navigationSpeedRangeZooms,
    );
    await dgisController.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.85));
    await dgisController.followNavigation();
    await dgisController.setMapAttributeBool(_navigatorOn, value: true);

    /// For some reason this map attribute doesn't sets sometimes on IOS devices
    /// This is needed to make sure that user car marker will be shown
    if (Platform.isIOS) {
      Future.delayed(const Duration(milliseconds: 500), () {
        dgisController.setMapAttributeBool(_navigatorOn, value: true);
      });
    }
  }

  Future<void> restoreNavigationState(void Function() onError) async {
    final dgisController = await ref.read(dgisControllerProvider.future);

    final state = base64.decode(
      ref.read(sharedPrefsProvider).getString(MapnessConstants.navigatorStateKey)!,
    );
    try {
      await dgisController.restoreNavigationState(
        state,
        NavigationConstants.navigationSpeedRangeZooms,
      );
    } catch (e) {
      onError();
    }
  }

  // Show the home page after the trip is finished
  Future<void> endTripAndShowHome({required BuildContext context}) async {
    final dgisController = ref.read(dgisControllerProvider);
    await ref.read(urbiAnalyticsProvider).track(MapnessConstants.analyticsTripStopped);
    await dgisController.value?.freeRoamController.stop();
    await dgisController.value?.setMapAttributeBool(_navigatorOn, value: false);
    await _parkingCheck();
    if (context.mounted) {
      context.router.popUntilRouteWithName(BottomMenuRoute.name);
    }
  }

  /// If I enable parking during [FreeRoam], after the check is completed they are hidden if hidden from [Layers].
  /// If it is enabled in [Layers], then if I disable it in [FreeRoam], then after completion they are also disabled
  Future<void> _parkingCheck() async {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final isParkingEnabledByFreeRoam = sharedPrefs.getBool(MapnessConstants.parkingEnabledFreeRoam) ?? false;

    if (isParkingEnabledByFreeRoam) {
      final layersControls = ref.read(layersControlsProvider.notifier);
      if (ref.read(activeLayerProvider) == LayerType.parkingLots) {
        await layersControls.hideActiveLayer();
      }
      await sharedPrefs.setBool(MapnessConstants.parkingEnabledFreeRoam, false);
    }
  }

  void deactivate() {
    // Only the camera anchor is restored here. The location follow state must not be
    // toggled: `toggleFollowState` is a cycle (off -> position -> direction), so on iOS it
    // turned the follow back on and pulled the camera to the current location right after
    // free roam was ended, while Android kept the last roaming position (TFS #34904).
    ref.read(dgisControllerProvider).value?.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.5));
  }
}

final freeRoamManagerProvider = _freeRoamManagerProvider;
