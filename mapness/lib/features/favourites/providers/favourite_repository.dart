import 'package:dio/dio.dart';
import 'package:mapness/features/common/providers/dgis_network.dart';
import 'package:mapness/features/favourites/domain/favourite_item.dart';
import 'package:mapness/features/favourites/domain/favourites_state.dart';
import 'package:mapness/features/favourites/mappers/add_request_item.dart';
import 'package:mapness/features/favourites/mappers/delete_favourite_items_request_item_mapper.dart';
import 'package:mapness/features/favourites/mappers/favourites_response_mapper.dart';
import 'package:mapness/generated/protocol/protocol.pb.dart' as proto;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favourite_repository.g.dart';

@riverpod
class FavouriteRepository extends _$FavouriteRepository {
  Dio get dio => ref.read(dGisNetworkProvider);

  Future<void> delete(FavouriteItem item) async {
    await deleteMany([item]);
  }

  Future<void> deleteAll() async {
    if (!state.hasValue) return;
    final data = state.requireValue;
    final items = [
      if (data.home != null) data.home!,
      if (data.work != null) data.work!,
      ...data.items,
    ];
    await deleteMany(items);
  }

  Future<void> deleteMany(List<FavouriteItem> items) async {
    final request = proto.DeleteFavouriteItemsRequest(
      items: items.map(
        (e) => DeleteFavouriteItemsRequestItemMapper.fromDomain(
            e, FavouriteItemMarkerType.place),
      ),
    );
    print(request.writeToJson());
    final raw = await dio.delete(
      'favourites',
      data: request.writeToBuffer(),
    );
    state = AsyncValue.data(
      proto.FavouritesResponse.fromBuffer(raw.data).toDomain(),
    );
  }

  void addItem(FavouriteItem item) {
    addItems([item]);
  }

  Future<void> addItems(List<FavouriteItem> items) async {
    final request = proto.AddFavouriteItemsRequest(
        items: items.map((e) =>
            AddRequestItemMapper.fromDomain(e, FavouriteItemMarkerType.place)));
    print(request.toString());
    final raw = await dio.post(
      'favourites',
      data: request.writeToBuffer(),
    );
    state = AsyncValue.data(
      proto.FavouritesResponse.fromBuffer(raw.data).toDomain(),
    );
  }

  Future<FavouritesState> fetchItems() async {
    final raw = await dio.get('favourites');
    final response = proto.FavouritesResponse.fromBuffer(raw.data);

    return response.toDomain();
  }

  @override
  Future<FavouritesState> build() async {
    return await fetchItems();
  }
}
