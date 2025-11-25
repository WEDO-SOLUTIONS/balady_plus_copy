import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/directory_object_from_dgis_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poi_search_by_object.g.dart';

@riverpod
class PoiSearchByObject extends _$PoiSearchByObject {
  @override
  Future<(List<DirectoryObjectMessage>, List<DirectoryObjectMessage>)> build(DirectoryObjectMessage? data) async {
    state = const AsyncValue.loading();

    final List<PublicTransportPlatformTransitionMessage> transitions = data
            ?.routeInfos.firstOrNull?.directions.firstOrNull?.platforms
            .firstWhereOrNull((platform) => platform.name == data.title)
            ?.transitions ??
        [];

    final results = <DirectoryObjectMessage>[];
    for (final transition in transitions) {
      final object = await ref.watch(
        directoryObjectFromDgisIdProvider(transition.routeId.toObjectId()).future,
      );

      if (object != null) {
        results.add(object);
      }
    }

    final entrances = data?.entrances ?? [];
    final resultsEntrances = <DirectoryObjectMessage>[];
    for (final entrance in entrances) {
      try {
        final object = await ref.watch(directoryObjectFromDgisIdProvider(
          DgisObjectId(objectId: entrance.id.entranceId, entranceId: 0),
        ).future);
        if (object != null) {
          resultsEntrances.add(object);
        }
      } catch (_) {
        // Handle the case where the entrance ID is not found or any other error
        continue;
      }
    }

    state = AsyncValue.data((results, resultsEntrances));
    return (results, resultsEntrances);
  }
}
