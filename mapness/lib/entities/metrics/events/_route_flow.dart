part of 'metrics_event.dart';

@freezed
abstract class MetricsRouteFlow with _$MetricsRouteFlow {
  const factory MetricsRouteFlow({
    required List<MetricsRouteFlowItem> routeStack,
  }) = _MetricsRouteFlow;

  const MetricsRouteFlow._();

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
    final filters = sequence.filters;
    final searchItems = sequence.items;
    Iterable<MetricsRouteFlowItem> filteredItems = routeStack;
    for (final filter in filters) {
      final currentItems = filteredItems.toList();
      filteredItems = filteredItems.whereIndexed(
        (i, route) => filter(currentItems, i, route),
      );
    }

    if (searchItems.length > filteredItems.length) {
      return false;
    }
    final lengthDiff = filteredItems.length - searchItems.length;

    // check starting from the top of stack
    for (int i = searchItems.length - 1; i >= 0; i--) {
      final searchItem = searchItems[i];
      final stackIndex = i + lengthDiff;
      final stackItem = filteredItems.elementAt(stackIndex);
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
