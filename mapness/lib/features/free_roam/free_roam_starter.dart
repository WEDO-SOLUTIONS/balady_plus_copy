import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'package:mapness/entities/free_roam/autostart_state.dart';
import 'package:mapness/entities/free_roam/free_roam_start_state.dart';
import 'package:mapness/features/free_roam/free_roam_autostart_settings.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'free_roam_starter.g.dart';

@riverpod
class _FreeRoamStarter extends _$FreeRoamStarter {
  static bool _isShown = false;
  bool get isShown => _isShown;

  ProviderSubscription<Position?>? _subscription;

  @override
  FreeRoamStartState build() {
    final autostartState = ref.watch(freeRoamAutostartSettingsProvider);

    if (autostartState == AutostartState.declined) {
      return const FreeRoamStartState(
        isAutorun: false,
        canStart: false,
        status: UnknownStatus(),
      );
    }
    final isAutorun = autostartState == AutostartState.always;

    void update(Position? _, Position? event) {
      if (autostartState == AutostartState.declined || _isShown) {
        return;
      }

      if (!state.canStart &&
          state.status is! AnimatingStatus &&
          event != null &&
          event.speed - event.speedAccuracy >= 8.33333) {
        state = state.copyWith(
          canStart: true,
          isAutorun: isAutorun,
          status: const UnknownStatus(),
        );
      }
    }

    if (!_isShown) {
      _subscription = ref.listen<Position?>(locationProvider, update);
    }

    ref.onDispose(() {
      _subscription?.close();
    });

    return FreeRoamStartState(
      isAutorun: isAutorun,
      canStart: false,
      status: const UnknownStatus(),
    );
  }

  void startAnimation() {
    state = state.copyWith(status: const AnimatingStatus());
  }

  void pauseAnimation() {
    if (state.status is! PausedStatus) {
      state = state.copyWith(status: const PausedStatus());
    }
  }

  void unpauseAnimation() {
    if (state.status is! AnimatingStatus) {
      state = state.copyWith(status: const AnimatingStatus());
    }
  }

  void setShown({bool setAutoStart = false}) {
    if (setAutoStart) {
      ref.read(freeRoamAutostartSettingsProvider.notifier).setState(isAutostart: true);
    }
    state = FreeRoamStartState(
      isAutorun: ref.read(freeRoamAutostartSettingsProvider) == AutostartState.always,
      canStart: false,
      status: const CompletedStatus(),
    );
    _isShown = true;
    _subscription?.close();
  }

  void reset() {
    _isShown = false;
    ref.invalidateSelf();
  }
}

final freeRoamStarterProvider = _freeRoamStarterProvider;
