import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/navigation_event.dart';
import 'package:dgis_map_platform_interface/src/events/route_options_event.dart';
import 'package:dgis_map_platform_interface/src/events/sound_on_events.dart';

/// Handles navigation events from DGisMapPlugin
class NavigationEventHandler {
  /// Constructor
  NavigationEventHandler();

  /// Broadcast stream for navigation event
  Stream<NavigationEvent> get navigationEvents => _controller.stream;

  /// Broadcast stream for route options event
  Stream<RouteOptionsEvent> get routeOptionEvents => _routeOptionsController.stream;

  /// Broadcast stream for sound on/off event
  /// If you want to listen to sound on/off event from CarPlay or Android Auto, use this stream
  Stream<SoundOnEvent> get soundOnEvents => _soundOnController.stream;

  final _controller = StreamController<NavigationEvent>.broadcast();
  final _routeOptionsController = StreamController<RouteOptionsEvent>.broadcast();
  final _soundOnController = StreamController<SoundOnEvent>.broadcast();

  /// Handles navigation event
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

  /// Handles route options event
  void routeOptionsEvent(Map<dynamic, dynamic> map) {
    final hasOptions = map["hasOptions"];

    _routeOptionsController.sink.add(
      RouteOptionsEvent(hasOptions: hasOptions),
    );
  }

  /// Handles sound on/off event
  void soundOnEvent(Map<dynamic, dynamic> map) {
    final value = map["value"];
    if (value is bool) {
      _soundOnController.sink.add(SoundOnEvent(value: value));
    }
  }

  /// Disposes the handler and closes all streams
  Future<void> dispose() async {
    await _soundOnController.close();
    await _routeOptionsController.close();
    await _controller.close();
  }
}
