import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'traffic_state.g.dart';

@Riverpod(keepAlive: true)
class TrafficState extends _$TrafficState {
  StreamSubscription<TrafficStateEvent>? _trafficSubscription;
  DgisMapController? _dgisController;

  @override
  TrafficStateEvent build() {
    // BALADY-3615: re-bind to the native controller whenever the map is
    // recreated. This provider is keepAlive while dgisControllerProvider is
    // not — the old one-shot `_initListeners` kept a subscription on the
    // dead map, so Dart never saw traffic status changes again:
    // isTrafficEnabled stayed false, every tap "enabled" traffic (actually
    // toggling it on the native side), and the overlay mutex skipped hiding
    // an enabled traffic layer.
    ref
      ..listen(
        dgisControllerProvider,
        (previous, next) {
          final controller = next.value;
          if (controller != null && !identical(controller, _dgisController)) {
            detach(_bind(controller), tag: 'trafficState.bind');
          }
        },
        fireImmediately: true,
      )
      ..onDispose(() {
        _trafficSubscription?.cancel();
        _detach(_dgisController);
        _dgisController = null;
      });

    return const TrafficStateEvent(status: TrafficControlStatus.hidden, score: 0);
  }

  Future<void> _bind(DgisMapController controller) async {
    await _trafficSubscription?.cancel();
    _detach(_dgisController);
    _dgisController = controller;

    await controller.naviTrafficParkingController.onAttached();
    if (!ref.mounted || !identical(controller, _dgisController)) {
      return;
    }
    _trafficSubscription = controller.naviTrafficParkingController.trafficStateEvents.listen((event) {
      // TEMP(BALADY-3615): trace — remove after QA confirms.
      logger.log(
        'layers: traffic event status=${event.status} score=${event.score}',
        logLevel: MapnessLogLevel.info,
      );
      state = event;
    });
  }

  void _detach(DgisMapController? controller) {
    if (controller == null) {
      return;
    }
    try {
      controller.naviTrafficParkingController.onDetached();
    } catch (_) {
      // The old map is already gone — nothing to detach from.
    }
  }

  void onTrafficTap() {
    _dgisController?.naviTrafficParkingController.onTrafficClicked();
  }

  bool get isTrafficEnabled => state.status == TrafficControlStatus.enabled;
}
