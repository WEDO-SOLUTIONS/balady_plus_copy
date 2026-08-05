import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'datafinder_source_tracker.g.dart';

/// Tracks the **origin surface** of the current user journey for DataFinder
/// `event_source`.
///
/// Balady is a single map screen with overlay controllers, so `event_source` is
/// not a route — it is decided by the entry control the user first touched and
/// then carried through navigation + search + favorite:
///  * a POI tapped directly on the map → [DataFinderOrigin.map]
///  * the Explore (Landing) tab UI → [DataFinderOrigin.explore] (also the default)
///  * the Routes flow → [DataFinderOrigin.routes]
///  * Free Roam → [DataFinderOrigin.freeRoam]
///
/// Entry controls **stamp** the origin when used (map POI tap, tab change, Free
/// Roam enter). Consumers resolve the final source on demand by combining the
/// stamped origin with the live navigation state via [DataFinderOrigin.resolve]:
///  * the search notifier, for every search event;
///  * `favorite_add`, which has no search scope, reads the same origin so a
///    direct map-POI favourite is `Map-Main Page` and a favourite from a
///    Routes/Direction search inherits that surface.
///
/// Defaults to [DataFinderOrigin.explore] (the home tab surface).
@Riverpod(keepAlive: true)
class DataFinderSourceTracker extends _$DataFinderSourceTracker {
  @override
  DataFinderOrigin build() => DataFinderOrigin.explore;

  /// Records the surface the user is starting a journey from. Called by entry
  /// controls (map POI tap, tab change, Free Roam).
  // ignore: use_setters_to_change_properties
  void stampOrigin(DataFinderOrigin origin) => state = origin;
}
