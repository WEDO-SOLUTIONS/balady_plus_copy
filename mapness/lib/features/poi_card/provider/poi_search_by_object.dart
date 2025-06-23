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
        directoryObjectFromDgisIdProvider(transition.routeId).future,
      );

      if (object != null) {
        results.add(object);
      }
    }

    final entrances = data?.entrances ?? [];
    final resultsEntrances = <DirectoryObjectMessage>[];
    for (final entrance in entrances) {
      final object = await ref.watch(directoryObjectFromDgisIdProvider(
        DgisObjectIdMessage(objectId: entrance.id.entranceId, entranceId: 0),
      ).future);

      if (object != null) {
        resultsEntrances.add(object);
      }
    }

    state = AsyncValue.data((results, resultsEntrances));
    return (results, resultsEntrances);
  }
}

@riverpod
class PoiSearchByObjectEntrances extends _$PoiSearchByObjectEntrances {
  @override
  Future<List<DirectoryObjectMessage>> build(DirectoryObjectMessage? data) async {
    state = const AsyncValue.loading();
    final entrances = data?.entrances ?? [];
    final results = <DirectoryObjectMessage>[];
    for (final entrance in entrances) {
      final object = await ref.watch(directoryObjectFromDgisIdProvider(entrance.id).future);

      if (object != null) {
        results.add(object);
      }
    }

    state = AsyncValue.data(results);
    return results;
  }
}
