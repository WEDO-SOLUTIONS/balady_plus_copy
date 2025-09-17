import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'traffic_state.g.dart';

@Riverpod(keepAlive: true)
class TrafficState extends _$TrafficState {
  StreamSubscription<TrafficStateEvent>? _trafficSubscription;
  DgisMapController? _dgisController;
  @override
  TrafficStateEvent build() {
    _initListeners();

    return const TrafficStateEvent(status: TrafficControlStatus.hidden, score: 0);
  }

  Future<void> _initListeners() async {
    _dgisController = await ref.read(dgisControllerProvider.future);

    await _dgisController?.naviTrafficParkingController.onAttached();
    _trafficSubscription =
        _dgisController?.naviTrafficParkingController.trafficStateEvents.listen((event) => state = event);

    ref.onDispose(
      () {
        _trafficSubscription?.cancel();
        _dgisController?.naviTrafficParkingController.onDetached();
      },
    );
  }

  void onTrafficTap() {
    _dgisController?.naviTrafficParkingController.onTrafficClicked();
  }

  bool get isTrafficEnabled => state.status == TrafficControlStatus.enabled;
}
