import 'package:dgis_map/library.dart';
import 'package:mapness/features/map/providers/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_bearing.g.dart';

class BearingState {
  final double angle;

  BearingState({
    required this.angle,
  });
}

@riverpod
class MapBearing extends _$MapBearing {
  @override
  BearingState build() {
    final dgisController = ref.watch(dgisControllerProvider);
    final bearingSubscription =
        dgisController?.compassBearingEvents.listen(_bearingListener);

    ref.onDispose(
      () {
        bearingSubscription?.cancel();
      },
    );

    return BearingState(angle: 0);
  }

  void _bearingListener(CompassBearingEvent event) {
    // if (event.button == ZoomControlType.zoomIn) {
    //   state = state.copyWith(zoomInEnabled: event.isEnabled);
    // } else {
    //   state = state.copyWith(zoomOutEnabled: event.isEnabled);
    // }
  }

  void onCompassTap() {
    // ref.watch(dgisControllerProvider)?.on;
  }
}
