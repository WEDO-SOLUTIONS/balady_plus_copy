import 'package:collection/collection.dart';
import 'package:mapness/features/favorite_lists/data/models/marker_color_code.dart';
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

/// Эффективный цвет маркера места, если оно избранное (иначе `null`).
@riverpod
Future<MarkerColorCode?> favoritePlaceMarkerColor(Ref ref, String placeId) async {
  final markers = await ref.watch(aggregatedFavoriteMarkersProvider.future);
  return markers.firstWhereOrNull((marker) => marker.placeId == placeId)?.markerColorCode;
}
