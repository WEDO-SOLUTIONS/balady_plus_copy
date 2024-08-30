import 'package:flutter/animation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/entities/free_roam/autostart_state.dart';
import 'package:mapness/entities/free_roam/free_roam_start_state.dart';
import 'package:mapness/features/free_roam/free_roam_autostart_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'free_roam_starter.g.dart';

@riverpod
class _FreeRoamStarter extends _$FreeRoamStarter {
  AnimationController? _controller;

  bool _isShown = false;
  bool get isShown => _isShown;

  @override
  FreeRoamStartState build() {
    final autostart = ref.read(freeRoamAutostartSettingsProvider);

    print('Speed: autostart=$autostart');

    if (autostart == AutostartState.declined) {
      return const FreeRoamStartState(
        isAutorun: false,
        canStart: false,
      );
    }
    final isAutorun = autostart == AutostartState.always;

    void updateState(Position event) {
      print('Speed: ${event.speed} ${event.speedAccuracy} $isAutorun');
      if (!(_controller?.isAnimating ?? false) && event.speed - event.speedAccuracy >= 0.53333) {
        state = state.copyWith(
          canStart: true,
          isAutorun: isAutorun,
        );
      }
    }

    const locationSettings = LocationSettings();
    final locationSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(updateState);

    ref.onDispose(locationSubscription.cancel);

    return FreeRoamStartState(
      isAutorun: isAutorun,
      canStart: false,
    );
  }

  void startAnimation(TickerProvider vsync, {Duration? duration}) {
    print('Speed: Start animation');
    _controller ??= AnimationController(vsync: vsync, duration: duration ?? const Duration(seconds: 10));
    _controller?.animateTo(1, curve: Curves.decelerate);
    _controller?.addStatusListener(_onComplete);
    state = state.copyWith(controller: _controller);
  }

  void pauseAnimation() {
    if (_controller?.isAnimating ?? false) {
      _controller?.stop(canceled: false);
    }
  }

  void unpauseAnimation() => _controller?.forward();

  void setShown() {
    print('Speed: set shown');
    _controller?.stop();
    _controller?.removeStatusListener(_onComplete);
    _controller?.dispose();
    _controller = null;
    state = FreeRoamStartState(
      isAutorun: state.isAutorun,
      canStart: false,
    );
    _isShown = true;
  }

  void _onComplete(status) {
    if (status == AnimationStatus.completed) {
      print('Speed: End animation ${_controller?.isCompleted}');
      if (_controller?.isCompleted ?? false) {
        setShown();
      }
    }
  }
}

final freeRoamStarterProvider = _freeRoamStarterProvider;
