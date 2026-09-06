import 'package:collection/collection.dart';
import 'package:mapness/features/favorite_lists/data/models/map_marker_dto.dart';
import 'package:mapness/features/favorite_lists/providers/aggregated_favorite_markers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_list_membership.g.dart';

/// Находится ли [placeId] хотя бы в одном списке избранного.
///
/// Источник — агрегированные маркеры по всем спискам (`getAggregatedMapMarkers`),
/// а не `places` из `getFavoriteLists()` — последнее на практике не заполнено
/// бэкендом, хотя DTO-комментарий утверждает обратное.
@riverpod
bool isPlaceFavorited(Ref ref, String placeId) {
  final markers = ref.watch(aggregatedFavoriteMarkersProvider).value;
  return markers?.any((marker) => marker.placeId == placeId) ?? false;
}

/// Удобная обёртка для мест, для которых есть только числовой DGIS objectId, а не строковый
/// `placeId` из favorite_lists API (например, POI-карточки).
@riverpod
bool isPlaceFavoritedByObjectId(Ref ref, int objectId) => ref.watch(isPlaceFavoritedProvider(objectId.toString()));

/// Маркер места в агрегированном списке избранного (цвет + иконка), если оно избранное (иначе `null`).
@riverpod
Future<MapMarkerDto?> favoritePlaceMarker(Ref ref, String placeId) async {
  final markers = await ref.watch(aggregatedFavoriteMarkersProvider.future);
  return markers.firstWhereOrNull((marker) => marker.placeId == placeId);
}
