import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'traffic_state.g.dart';

class Traffic {
  final TrafficControlStatus status;
  final int? score;

  Traffic({
    required this.status,
    this.score,
  });
}

@riverpod
class TrafficState extends _$TrafficState {
  @override
  Traffic build() {
    final dgisController = ref.watch(dgisControllerProvider);
    final trafficSubscription = dgisController
        ?.naviTrafficParkingController.trafficStateEvents
        .listen(_trafficListener);
    dgisController?.naviTrafficParkingController.onAttached();
    ref.onDispose(
      () {
        trafficSubscription?.cancel();
        dgisController?.naviTrafficParkingController.onDetached();
      },
    );

    return Traffic(
      status: TrafficControlStatus.disabled,
    );
  }

  void _trafficListener(TrafficStateEvent event) {
    state = Traffic(status: event.status, score: event.score);
  }

  void onTrafficTap() {
    ref
        .watch(dgisControllerProvider)
        ?.naviTrafficParkingController
        .onTrafficClicked();
  }
}
