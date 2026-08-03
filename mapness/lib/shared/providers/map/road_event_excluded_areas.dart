import 'package:dgis_map/library.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'road_event_excluded_areas.g.dart';

// Integration point for the Report Road Event feature: once road events cross
// the Event Routing Matrix threshold, this should return one ExcludedAreaMessage
// per qualifying event (capped at the SDK's 25-area limit) instead of an empty list.
@riverpod
List<ExcludedAreaMessage> roadEventExcludedAreas(Ref ref) => const [];
