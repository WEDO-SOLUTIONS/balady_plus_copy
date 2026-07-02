part of 'metrics_event.dart';

/// returns true if current [item] should be kept in the list
typedef MetricsRouteFlowFilter = bool Function(List<MetricsRouteFlowItem> items, int i, MetricsRouteFlowItem item);

class MetricsRouteFlowSequenceItem extends Equatable {
  final String routeName;
  final MetricsRouteOperation operation;

  const MetricsRouteFlowSequenceItem({required this.routeName, required this.operation});

  MetricsRouteFlowSequenceItem.flowItem(MetricsRouteFlowItem flowItem)
    : routeName = flowItem.route.routeName,
      operation = flowItem.operation;

  const MetricsRouteFlowSequenceItem.push(this.routeName) : operation = MetricsRouteOperation.push;

  @override
  List<Object?> get props => [routeName, operation];

  bool equalsFlowItem(MetricsRouteFlowItem item) => item.operation == operation && item.route.routeName == routeName;
}

// write tests
class MetricsRouteFlowFilters {
  static MetricsRouteFlowFilter and(List<MetricsRouteFlowFilter> filters) => (items, i, item) {
    for (final f in filters) {
      if (!f(items, i, item)) {
        return false;
      }
    }

    return true;
  };

  static MetricsRouteFlowFilter or(List<MetricsRouteFlowFilter> filters) => (items, i, item) {
    for (final f in filters) {
      if (f(items, i, item)) {
        return true;
      }
    }

    return false;
  };

  static final onlyPushFilter = (List<MetricsRouteFlowItem> items, int i, MetricsRouteFlowItem item) =>
      item.operation == MetricsRouteOperation.push;

  /// removes consecutive identical elements
  static MetricsRouteFlowFilter skipDuplicates = (items, i, item) {
    if (i == 0) {
      return true;
    }
    final previousItem = items[i - 1];
    if (MetricsRouteFlowSequenceItem.flowItem(item).equalsFlowItem(previousItem)) {
      return false;
    }
    return true;
  };
}

class MetricsRouteFlowSequence extends Equatable {
  final List<MetricsRouteFlowSequenceItem> items;
  final List<MetricsRouteFlowFilter> filters;

  const MetricsRouteFlowSequence({required this.items, required this.filters});

  MetricsRouteFlowSequence.onlyPush(this.items) : filters = [MetricsRouteFlowFilters.onlyPushFilter];

  @override
  List<Object?> get props => [items, filters];

  // byte dance metrics
  static final mapMainPage = MetricsRouteFlowSequence(
    items: const [
      MetricsRouteFlowSequenceItem.push(PoiCardWidgetRoute.name),
      MetricsRouteFlowSequenceItem.push(RoutingRoutesRoute.name),
      MetricsRouteFlowSequenceItem.push(PathNavRoute.name),
      MetricsRouteFlowSequenceItem.push(NaviSearchRoute.name),
    ],
    filters: [
      MetricsRouteFlowFilters.onlyPushFilter,
      MetricsRouteFlowFilters.skipDuplicates,
    ],
  );

  // byte dance metrics
  static final mapDirectionPathChanging = MetricsRouteFlowSequence(
    items: const [
      MetricsRouteFlowSequenceItem.push(PoiCardWidgetRoute.name),
      MetricsRouteFlowSequenceItem.push(RoutingRoutesRoute.name),
      MetricsRouteFlowSequenceItem.push(RoutingSearchSheetRoute.name),
    ],
    filters: [
      MetricsRouteFlowFilters.onlyPushFilter,
      MetricsRouteFlowFilters.skipDuplicates,
    ],
  );
}
