import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favourites/mappers/favourite_item_place_entity_mapper.dart';
import 'package:mapness/features/favourites/mappers/favourite_item_place_mapper.dart';
import 'package:mapness/features/favourites/mappers/point_mapper.dart';

extension FavouriteItemMapper on proto.FavouriteItem {
  FavouriteItem toDomain() => FavouriteItem(
        coordinates: place.location.point.toDomain(),
        id: id,
        title: place.title,
        subtitle: place.subtitle,
        entity: place.entity.toDomain(),
      );

  proto.FavouriteItem fromDomain(FavouriteItem item) => proto.FavouriteItem(
        id: item.id,
        place: FavouriteItemPlaceMapper.fromDomain(item),
      );
}

extension FavouriteItemMessageMapper on FavouriteItem {
  FavouriteItemMessage get message => FavouriteItemMessage(
        id: id,
        subtitle: subtitle,
        title: title,
        coordinates: GeoPointMessage(latitude: coordinates.latitude, longitude: coordinates.longitude),
      );
}
