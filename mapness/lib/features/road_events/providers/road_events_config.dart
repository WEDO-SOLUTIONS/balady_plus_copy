import 'package:mapness/features/road_events/data/road_events_datasource.dart';
import 'package:mapness/features/road_events/data/road_events_dio.dart';
import 'package:mapness/features/road_events/domain/road_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'road_events_config.g.dart';

/// Client-side tunables from `GET /config` (Road Event Service) — fetched once
/// per map session (no ETag/304 revalidation for now). On failure, falls back
/// to the hardcoded defaults that predate this config (`RoadEventConfig.fallback`),
/// so dependents never need to special-case a config-fetch failure.
@Riverpod(keepAlive: true)
Future<RoadEventConfig> roadEventsConfig(Ref ref) async {
  final dio = await ref.watch(roadEventsDioProvider.future);
  final datasource = RoadEventsDatasource(dio: dio);
  try {
    return await datasource.fetchConfig();
  } on Object {
    return RoadEventConfig.fallback;
  }
}
