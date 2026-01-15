import 'package:mapness/entities/path_nav/models/path_nav_speed_info.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path_nav_speed_info.g.dart';

@riverpod
class _PathNavSpeedInfo extends _$PathNavSpeedInfo {
  @override
  PathNavSpeedInfo build() {
    final speedController = ref.watch(dgisControllerProvider).value?.naviSpeedController;
    final camerasSub = speedController?.cameraEvents.listen((event) {
      state = state.copyWith(direction: event.direction);
    });
    final currentSpeedSub = speedController?.currentSpeedEvents.listen((event) {
      state = state.copyWith(speed: event);
    });
    final exceededSpeedSub = speedController?.exceedSpeedLimitEvents.listen((event) {
      state = state.copyWith(speedExceed: event);
    });
    final speedLimitSub = speedController?.speedLimitEvents.listen((event) {
      state = state.copyWith(speedLimit: event);
    });

    ref.onDispose(() {
      camerasSub?.cancel();
      currentSpeedSub?.cancel();
      exceededSpeedSub?.cancel();
      speedLimitSub?.cancel();
    });

    return const PathNavSpeedInfo(
      direction: null,
      speed: 0,
      speedLimit: null,
      speedExceed: false,
    );
  }
}

final pathNavSpeedInfoProvider = _pathNavSpeedInfoProvider;
