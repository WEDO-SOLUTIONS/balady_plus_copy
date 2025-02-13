import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/entities/favourites/favourite_item.dart';

extension FavouriteItemPlaceEntityMapper on proto.FavouriteItemPlace_Entity {
  FavouriteItemEntity toDomain() => FavouriteItemEntity(
        id: id,
        sourceType: switch (sourceType) {
          proto.EntitySourceType.ENTITY_SOURCE_UNKNOWN => EntitySourceType.unknown,
          proto.EntitySourceType.ENTITY_SOURCE_URBI => EntitySourceType.urbi,
          _ => throw UnimplementedError(),
        },
      );

  static proto.FavouriteItemPlace_Entity fromDomain(
    FavouriteItemEntity entity,
  ) =>
      proto.FavouriteItemPlace_Entity(
        id: entity.id,
        sourceType: switch (entity.sourceType) {
          EntitySourceType.unknown => proto.EntitySourceType.ENTITY_SOURCE_UNKNOWN,
          EntitySourceType.urbi => proto.EntitySourceType.ENTITY_SOURCE_URBI,
        },
      );
}
