import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/entity/models/favorite_cache_item.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';

import '../domain/favourites_state.dart';

extension FavoriteCacheItemMapper on FavouriteItem {
  FavoriteCacheItem toHive() => FavoriteCacheItem(
        id: id,
        subtitle: subtitle,
        title: title,
        coordinates: HiveCoordinates(
          latitude: coordinates.latitude,
          longitude: coordinates.longitude,
        ),
        entity: entity != null
            ? HiveFavouriteItemEntity(
                sourceType: entity!.sourceType.index,
                id: entity!.id,
              )
            : null,
      );
}

extension HiveFavouriteItemMapper on FavoriteCacheItem {
  FavouriteItem toDomain() => FavouriteItem(
        id: id,
        subtitle: subtitle,
        title: title,
        coordinates: Coordinates(
          latitude: coordinates.latitude,
          longitude: coordinates.longitude,
        ),
        entity: entity != null
            ? FavouriteItemEntity(
                sourceType: EntitySourceType.values[entity!.sourceType],
                id: entity!.id,
              )
            : null,
      );
}

extension FavoriteCacheStateX on FavouritesState {
  FavoriteCacheState toHive() => FavoriteCacheState(
        home: home?.toHive(),
        work: work?.toHive(),
        places: items.map((e) => e.toHive()).toList(),
      );
}

extension HiveFavoriteCacheStateX on FavoriteCacheState {
  FavouritesState toDomain() => FavouritesState(
        home: home?.toDomain(),
        work: work?.toDomain(),
        items: places?.map((e) => e.toDomain()).toList() ?? [],
      );
}
