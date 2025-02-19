import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favourites/mappers/favourite_item_marker_type_mapper.dart';

extension DeleteFavouriteItemsRequestItemMapper on proto.DeleteFavouriteItemsRequest_Item {
  static proto.DeleteFavouriteItemsRequest_Item fromDomain(
    FavouriteItem item,
    FavouriteItemMarkerType markerType,
  ) =>
      proto.DeleteFavouriteItemsRequest_Item(
        type: FavouriteItemMarkerTypeMapper.fromDomain(markerType),
        id: item.id,
      );
}
