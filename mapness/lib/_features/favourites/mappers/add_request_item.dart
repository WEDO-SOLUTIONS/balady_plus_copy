import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/mappers/entity_source_type_mapper.dart';
import 'package:mapness/_features/favourites/mappers/favourite_item_marker_type_mapper.dart';
import 'package:mapness/_features/favourites/mappers/point_mapper.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;

extension AddRequestItemMapper on proto.AddFavouriteItemsRequest_Item {
  static proto.AddFavouriteItemsRequest_Item fromDomain(
    FavouriteItem item,
    FavouriteItemMarkerType markerType,
  ) {
    return proto.AddFavouriteItemsRequest_Item(
      type: FavouriteItemMarkerTypeMapper.fromDomain(markerType),
      point: PointMapper.fromDomain(item.coordinates),
      // TODO: add title and subtitle when back ready
      entity: item.entity == null
          ? null
          : proto.AddFavouriteItemsRequest_Item_Entity(
              id: item.entity!.id,
              sourceType: EntitySourceTypeMapper.fromDomain(
                item.entity!.sourceType,
              ),
            ),
    );
  }
}
