import 'package:mapness/features/favourites/domain/favourite_item.dart';
import 'package:mapness/features/favourites/mappers/favourite_item_marker_type_mapper.dart';
import 'package:mapness/generated/protocol/protocol.pb.dart' as proto;

extension DeleteFavouriteItemsRequestItemMapper
    on proto.DeleteFavouriteItemsRequest_Item {
  static proto.DeleteFavouriteItemsRequest_Item fromDomain(
    FavouriteItem item,
    FavouriteItemMarkerType markerType,
  ) {
    return proto.DeleteFavouriteItemsRequest_Item(
      type: FavouriteItemMarkerTypeMapper.fromDomain(markerType),
      id: item.id,
    );
  }
}
