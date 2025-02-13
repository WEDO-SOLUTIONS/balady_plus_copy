import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/entities/favourites/favourites_state.dart';
import 'package:mapness/features/favourites/mappers/favourite_item_mapper.dart';
import 'package:mapness/features/favourites/mappers/favourite_item_place_mapper.dart';

extension FavouritesResponseMapper on proto.FavouritesResponse {
  FavouritesState toDomain() => FavouritesState(
        work: places.work.toDomain(),
        home: places.home.toDomain(),
        items: items.map((e) => e.toDomain()).toList(),
      );
}
