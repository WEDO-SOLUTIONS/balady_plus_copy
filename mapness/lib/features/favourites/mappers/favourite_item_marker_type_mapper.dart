import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/entities/favourites/favourite_item.dart';

typedef _FIT = proto.FavouriteItemType;
typedef _FIMT = FavouriteItemMarkerType;

extension FavouriteItemMarkerTypeMapper on FavouriteItemMarkerType {
  static FavouriteItemMarkerType toDomain(proto.FavouriteItemType type) => switch (type) {
        _FIT.FAVOURITE_ITEM_TYPE_UNKNOWN => _FIMT.unknown,
        _FIT.FAVOURITE_ITEM_TYPE_HOME => _FIMT.home,
        _FIT.FAVOURITE_ITEM_TYPE_WORK => _FIMT.work,
        _FIT.FAVOURITE_ITEM_TYPE_PLACE => _FIMT.place,
        _ => throw UnimplementedError(),
      };

  static proto.FavouriteItemType fromDomain(FavouriteItemMarkerType type) => switch (type) {
        _FIMT.unknown => _FIT.FAVOURITE_ITEM_TYPE_UNKNOWN,
        _FIMT.home => _FIT.FAVOURITE_ITEM_TYPE_HOME,
        _FIMT.work => _FIT.FAVOURITE_ITEM_TYPE_WORK,
        _FIMT.place => _FIT.FAVOURITE_ITEM_TYPE_PLACE,
      };
}
