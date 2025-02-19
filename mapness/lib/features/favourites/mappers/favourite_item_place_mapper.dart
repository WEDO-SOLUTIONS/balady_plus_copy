import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favourites/mappers/favourite_item_place_entity_mapper.dart';
import 'package:mapness/features/favourites/mappers/point_mapper.dart';

extension FavouriteItemPlaceMapper on proto.FavouriteItemPlace {
  FavouriteItem? toDomain() {
    if (entity.id == '') {
      return null;
    }

    return FavouriteItem(
      id: entity.id,
      title: title,
      subtitle: subtitle,
      entity: entity.toDomain(),
      coordinates: location.point.toDomain(),
    );
  }

  static proto.FavouriteItemPlace fromDomain(FavouriteItem item) => proto.FavouriteItemPlace(
        title: item.title,
        subtitle: item.subtitle,
        entity: item.entity == null ? null : FavouriteItemPlaceEntityMapper.fromDomain(item.entity!),
      );
}
