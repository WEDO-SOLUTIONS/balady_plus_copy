import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favorite_lists/providers/aggregated_favorite_markers.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_place_poi.dart';
import 'package:mapness/features/favorite_lists/providers/home_work_favorites.dart';
import 'package:mapness/features/favourites/helpers/favourite_entity_id.dart';
import 'package:mapness/features/favourites/mappers/directory_object_message_mapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_favourite_items.g.dart';

/// All favourited places — Home, Work, and every place in the user's regular lists —
/// resolved into display-ready [FavouriteItem]s (Home/Work first, then the rest).
///
/// Shared mapper for screens that render a flat list of favourites (e.g. `NaviFavoritesPage`,
/// `FavouritesPicker`) — resolves each `MapMarkerDto` via `favoriteListPlacePoiProvider`, the same
/// way `_FavouriteMarkers` resolves map pins.
@riverpod
Future<List<FavouriteItem>> allFavouriteItems(Ref ref) async {
  final homeWork = await ref.watch(homeWorkFavoritesProvider.future);
  final markers = await ref.watch(aggregatedFavoriteMarkersProvider.future);

  final homeObjectId = parseObjectIdFromFavouriteEntityId(homeWork.home?.entity?.id)?.toString();
  final workObjectId = parseObjectIdFromFavouriteEntityId(homeWork.work?.entity?.id)?.toString();

  final resolvedItems = await Future.wait(
    markers
        // Home/Work are added separately below with their own identity; skip them here —
        // the aggregated API also includes them since they're just two more hidden lists.
        .where((marker) => marker.placeId != homeObjectId && marker.placeId != workObjectId)
        .map((marker) async {
          final objectId = int.tryParse(marker.placeId);
          if (objectId == null) {
            return null;
          }
          final poi = await ref.watch(favoriteListPlacePoiProvider(objectId).future);
          return poi?.mapToFavourite();
        }),
  );

  return [
    if (homeWork.home != null) homeWork.home!,
    if (homeWork.work != null) homeWork.work!,
    ...resolvedItems.nonNulls,
  ];
}
