import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'traffic_state.g.dart';

@riverpod
class _TrafficState extends _$TrafficState {
  @override
  TrafficStateEvent build() {
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

    return const TrafficStateEvent(
      score: 0,
      status: TrafficControlStatus.hidden,
    );
  }

  void _trafficListener(TrafficStateEvent event) {
    state = event;
  }

  void onTrafficTap() {
    ref
        .watch(dgisControllerProvider)
        ?.naviTrafficParkingController
        .onTrafficClicked();
  }
}

final trafficStateProvider = _trafficStateProvider;
