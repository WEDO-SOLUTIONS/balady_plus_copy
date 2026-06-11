part of 'metrics_event.dart';

@freezed
abstract class MetricsRouteFlow with _$MetricsRouteFlow {
  const factory MetricsRouteFlow({
    required List<MetricsRouteFlowItem> routeStack,
  }) = _MetricsRouteFlow;

  const MetricsRouteFlow._();

  static final onlyPushFilter = (MetricsRouteFlowItem item) => item.operation == MetricsRouteOperation.push;

  MetricsRouteFlow pushItem(MetricsRouteFlowItem item, {int? sizeLimit = 100}) {
    var newStack = [...routeStack, item];
    if (sizeLimit != null && newStack.length > sizeLimit) {
      newStack = newStack.sublist(1);
    }
    return copyWith(routeStack: newStack);
  }

  (MetricsRouteFlowItem?, MetricsRouteFlow) popItem() {
    if (routeStack.isEmpty) {
      return (null, this);
    }
    final routeStackCopy = [...routeStack];
    final poppedElement = routeStackCopy.removeLast();
    return (poppedElement, copyWith(routeStack: routeStackCopy));
  }

  bool containsRouteSequence(MetricsRouteFlowSequence sequence) {
    final filter = sequence.filter;
    final searchItems = sequence.items;
    final filteredItems = filter == null ? routeStack : routeStack.where(filter).toList();

    if (searchItems.length > filteredItems.length) {
      return false;
    }

    for (int i = 0; i < searchItems.length; i++) {
      final searchItem = searchItems[i];
      final stackItem = filteredItems[i];
      if (!searchItem.equalsFlowItem(stackItem)) {
        return false;
      }
    }

    return true;
  }
}

class MetricsRouteFlowItem extends Equatable {
  final PageRouteInfo route;
  final MetricsRouteOperation operation;

  const MetricsRouteFlowItem({required this.route, required this.operation});

  @override
  List<Object?> get props => [route, operation];
}

enum MetricsRouteOperation { push, pop, changeTab, replace }
