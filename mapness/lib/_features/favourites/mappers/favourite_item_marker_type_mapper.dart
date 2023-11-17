import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;

typedef _FIT = proto.FavouriteItemType;
typedef _FIMT = FavouriteItemMarkerType;

extension FavouriteItemMarkerTypeMapper on FavouriteItemMarkerType {
  static FavouriteItemMarkerType toDomain(proto.FavouriteItemType type) {
    return switch (type) {
      _FIT.FAVOURITE_ITEM_TYPE_UNKNOWN => _FIMT.unknown,
      _FIT.FAVOURITE_ITEM_TYPE_HOME => _FIMT.home,
      _FIT.FAVOURITE_ITEM_TYPE_WORK => _FIMT.work,
      _FIT.FAVOURITE_ITEM_TYPE_PLACE => _FIMT.place,
      _ => throw UnimplementedError(),
    };
  }

  static proto.FavouriteItemType fromDomain(FavouriteItemMarkerType type) {
    return switch (type) {
      _FIMT.unknown => _FIT.FAVOURITE_ITEM_TYPE_UNKNOWN,
      _FIMT.home => _FIT.FAVOURITE_ITEM_TYPE_HOME,
      _FIMT.work => _FIT.FAVOURITE_ITEM_TYPE_WORK,
      _FIMT.place => _FIT.FAVOURITE_ITEM_TYPE_PLACE,
    };
  }
}
