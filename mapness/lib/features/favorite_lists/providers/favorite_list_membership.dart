import 'package:collection/collection.dart';
import 'package:mapness/features/favorite_lists/data/models/map_marker_dto.dart';
import 'package:mapness/features/favorite_lists/providers/aggregated_favorite_markers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_list_membership.g.dart';

/// Whether [placeId] is present in at least one favorite list.
///
/// Source is the aggregated markers across all lists (`getAggregatedMapMarkers`),
/// not `places` from `getFavoriteLists()` — the latter is not actually populated
/// by the backend in practice, even though the DTO comment claims otherwise.
@riverpod
bool isPlaceFavorited(Ref ref, String placeId) {
  final markers = ref.watch(aggregatedFavoriteMarkersProvider).value;
  return markers?.any((marker) => marker.placeId == placeId) ?? false;
}

/// Convenience wrapper for places that only have a numeric DGIS objectId rather than
/// a string `placeId` from the favorite_lists API (e.g. POI cards).
@riverpod
bool isPlaceFavoritedByObjectId(Ref ref, int objectId) => ref.watch(isPlaceFavoritedProvider(objectId.toString()));

/// The place's marker in the aggregated favorites list (color + icon), if it's favorited (`null` otherwise).
@riverpod
Future<MapMarkerDto?> favoritePlaceMarker(Ref ref, String placeId) async {
  final markers = await ref.watch(aggregatedFavoriteMarkersProvider.future);
  return markers.firstWhereOrNull((marker) => marker.placeId == placeId);
}
