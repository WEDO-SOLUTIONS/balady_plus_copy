part of 'metrics_event.dart';

class MetricsRouteFlowSequenceItem extends Equatable {
  final String routeName;
  final MetricsRouteOperation operation;

  const MetricsRouteFlowSequenceItem({required this.routeName, required this.operation});

  const MetricsRouteFlowSequenceItem.push(this.routeName) : operation = MetricsRouteOperation.push;

  @override
  List<Object?> get props => [routeName, operation];

  bool equalsFlowItem(MetricsRouteFlowItem item) => item.operation == operation && item.route.routeName == routeName;
}

class MetricsRouteFlowSequence extends Equatable {
  final List<MetricsRouteFlowSequenceItem> items;
  final bool Function(MetricsRouteFlowItem item)? filter;

  const MetricsRouteFlowSequence({required this.items, required this.filter});

  MetricsRouteFlowSequence.onlyPush(this.items) : filter = MetricsRouteFlow.onlyPushFilter;

  @override
  List<Object?> get props => [items, filter];

  // byte dance metrics
  static final mapMainPage = MetricsRouteFlowSequence.onlyPush(
    const [
      MetricsRouteFlowSequenceItem.push(PoiCardWidgetRoute.name),
    ],
  );
}
