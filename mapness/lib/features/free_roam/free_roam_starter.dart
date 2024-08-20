import 'package:mapness/entities/free_roam/free_roam_start_timer.dart';

import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'free_roam_starter.g.dart';

@riverpod
class _FreeRoamStarter extends _$FreeRoamStarter {
  static DateTime? startDriving;

  @override
  FreeRoamStartTimer build() {
    final speedController = ref.watch(dgisControllerProvider).value?.naviSpeedController;

    final currentSpeedSub = speedController?.currentSpeedEvents.listen((speed) {
      if (speed != null && speed >= 30) {
        startDriving ??= DateTime.now();

        state = state.copyWith(
          canStart: true,
          timeElapsed: DateTime.now().difference(startDriving!),
        );
      } else {
        startDriving = null;
        state = state.copyWith(
          canStart: false,
        );
      }
    });

    ref.onDispose(() {
      currentSpeedSub?.cancel();
    });

    return const FreeRoamStartTimer(
      isAutorun: true,
      canStart: true,
    );
  }
}

final freeRoamStarterProvider = _freeRoamStarterProvider;
