import 'package:dgis_map/library.dart';

///Controller for free roam mode
class NaviFreeRoamController {
  /// @nodoc
  NaviFreeRoamController(
    this.events, {
    required this.start,
    required this.stop,
  });

  ///All events
  final Stream<NavigationEvent> events;

  ///Starts free roam navigator mode
  Future<void> Function(List<SpeedRangeZoom> speedRangeZoom) start;

  ///Stops free roam navigator mode
  Future<void> Function() stop;
}
