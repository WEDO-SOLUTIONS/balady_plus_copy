import 'package:mapness/features/favourites/domain/favourite_item.dart';
import 'package:mapness/features/favourites/mappers/favourite_item_place_entity_mapper.dart';
import 'package:mapness/features/favourites/mappers/point_mapper.dart';
import 'package:mapness/generated/protocol/protocol.pb.dart' as proto;

extension FavouriteItemPlaceMapper on proto.FavouriteItemPlace {
  FavouriteItem toDomain() {
    return FavouriteItem(
      id: entity.id,
      title: title,
      subtitle: subtitle,
      entity: entity.toDomain(),
      coordinates: location.point.toDomain(),
    );
  }

  static proto.FavouriteItemPlace fromDomain(FavouriteItem item) {
    return proto.FavouriteItemPlace(
      title: item.title,
      subtitle: item.subtitle,
      entity: item.entity == null
          ? null
          : FavouriteItemPlaceEntityMapper.fromDomain(item.entity!),
    );
  }
}
