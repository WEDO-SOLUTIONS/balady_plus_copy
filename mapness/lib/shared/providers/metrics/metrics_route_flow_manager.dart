import 'package:mapness/entities/metrics/events/metrics_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'metrics_route_flow_manager.g.dart';

@Riverpod(keepAlive: true)
class MetricsRouteFlowManager extends _$MetricsRouteFlowManager {
  @override
  MetricsRouteFlow build() => const MetricsRouteFlow(routeStack: []);

  void pushItem(MetricsRouteFlowItem item) {
    state = state.pushItem(item);
  }

  MetricsRouteFlowItem? popItem() {
    final (poppedItem, flow) = state.popItem();
    if (poppedItem == null) {
      return null;
    }

    state = flow;
    return poppedItem;
  }
}
