import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/entities/favourites/favourites_state.dart';
import 'package:mapness/features/favourites/data/models/favorite_cache_item.dart';
import 'package:mapness/shared/entities/coordinates.dart';

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
