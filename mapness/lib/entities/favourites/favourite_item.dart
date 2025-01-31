import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';

class FavouriteItem {
  const FavouriteItem({
    required this.coordinates,
    required this.id,
    required this.subtitle,
    required this.title,
    this.entity,
  });
  final String id;
  final String subtitle;
  final String title;
  final Coordinates coordinates;
  final FavouriteItemEntity? entity;
}

class FavouriteItemEntity {
  const FavouriteItemEntity({
    required this.sourceType,
    required this.id,
  });
  final EntitySourceType sourceType;
  final String id;
}

enum EntitySourceType {
  unknown,
  urbi,
}

enum FavouriteItemMarkerType {
  unknown,
  home,
  work,
  place,
}
