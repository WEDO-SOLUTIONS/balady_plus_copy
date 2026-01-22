import 'package:hive_ce/hive.dart';

part 'favorite_cache_item.g.dart';

@HiveType(typeId: 2)
class FavoriteCacheItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String subtitle;

  @HiveField(2)
  String title;

  @HiveField(3)
  HiveCoordinates coordinates;

  @HiveField(4)
  HiveFavouriteItemEntity? entity;

  FavoriteCacheItem({
    required this.id,
    required this.subtitle,
    required this.title,
    required this.coordinates,
    this.entity,
  });
}

@HiveType(typeId: 3)
class HiveCoordinates extends HiveObject {
  @HiveField(0)
  double latitude;

  @HiveField(1)
  double longitude;

  HiveCoordinates({
    required this.latitude,
    required this.longitude,
  });
}

@HiveType(typeId: 4)
class HiveFavouriteItemEntity extends HiveObject {
  @HiveField(0)
  int sourceType;

  @HiveField(1)
  String id;

  HiveFavouriteItemEntity({
    required this.sourceType,
    required this.id,
  });
}

@HiveType(typeId: 5)
class FavoriteCacheState extends HiveObject {
  @HiveField(0)
  FavoriteCacheItem? home;

  @HiveField(1)
  FavoriteCacheItem? work;

  @HiveField(2)
  List<FavoriteCacheItem>? places;

  FavoriteCacheState({
    this.home,
    this.work,
    this.places,
  });
}
