import 'package:mapness/features/favourites/domain/favourites_state.dart';
import 'package:mapness/features/favourites/mappers/favourite_item_mapper.dart';
import 'package:mapness/features/favourites/mappers/favourite_item_place_mapper.dart';
import 'package:mapness/generated/protocol/protocol.pb.dart' as proto;

extension FavouritesResponseMapper on proto.FavouritesResponse {
  FavouritesState toDomain() {
    return FavouritesState(
      work: places.work.toDomain(),
      home: places.home.toDomain(),
      items: items.map((e) => e.toDomain()).toList(),
    );
  }
}
