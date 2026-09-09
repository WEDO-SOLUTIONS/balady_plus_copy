import 'dart:math';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bearing_state.g.dart';

class Bearing {
  Bearing({
    required this.bearing,
    required this.angle,
  });
  final double angle;
  final double bearing;
}

@riverpod
class BearingState extends _$BearingState {
  @override
  Bearing build() {
    final dgisController = ref.watch(dgisControllerProvider);
    final bearingSubscription = dgisController.value?.compassBearingEvents.listen(_bearingListener);

    ref.onDispose(
      () {
        bearingSubscription?.cancel();
      },
    );

    return Bearing(
      bearing: 0,
      angle: 0,
    );
  }

  void _bearingListener(CompassBearingEvent event) {
    final bearing = event.value;
    final angle = pi * (180 - bearing) / 180;

    state = Bearing(
      bearing: bearing,
      angle: angle,
    );
  }

  void onCompassTap() {
    ref.read(dgisControllerProvider).value?.naviCompassController.onCompassClicked();
  }
}
