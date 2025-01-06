import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/navigation_event.dart';
import 'package:dgis_map_platform_interface/src/events/route_options_event.dart';

class NavigationEventHandler {
  NavigationEventHandler();

  Stream<NavigationEvent> get navigationEvents => _controller.stream;

  Stream<RouteOptionsEvent> get routeOptionEvents => _routeOptionsController.stream;

  final _controller = StreamController<NavigationEvent>.broadcast();
  final _routeOptionsController = StreamController<RouteOptionsEvent>.broadcast();

  void handleNavigationEvent(Map<dynamic, dynamic> map) {
    final value = map["state"];

    if (value == NavigationEvent.finished.name) {
      return _controller.sink.add(NavigationEvent.finished);
    }

    if (value == NavigationEvent.disabled.name) {
      return _controller.sink.add(NavigationEvent.disabled);
    }

    if (value == NavigationEvent.navigation.name) {
      return _controller.sink.add(NavigationEvent.navigation);
    }

    if (value == NavigationEvent.routeSearch.name) {
      return _controller.sink.add(NavigationEvent.routeSearch);
    }
  }

  void routeOptionsEvent(Map<dynamic, dynamic> map) {
    final hasOptions = map["hasOptions"];

    _routeOptionsController.sink.add(
      RouteOptionsEvent(hasOptions: hasOptions),
    );
  }

  Future<void> dispose() {
    return _controller.close();
  }
}
