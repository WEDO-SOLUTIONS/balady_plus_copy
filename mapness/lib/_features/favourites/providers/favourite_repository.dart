import 'package:dio/dio.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/domain/favourites_state.dart';
import 'package:mapness/_features/favourites/mappers/add_request_item.dart';
import 'package:mapness/_features/favourites/mappers/delete_favourite_items_request_item_mapper.dart';
import 'package:mapness/_features/favourites/mappers/favourites_response_mapper.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/entry_point.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favourite_repository.g.dart';

final favouriteRepositoryProvider = _favouriteRepositoryProvider;

@riverpod
class _FavouriteRepository extends _$FavouriteRepository {
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
    final dio = await ref.read(dGisNetworkProvider.future);
    final request = proto.DeleteFavouriteItemsRequest(
      items: items.map(
        (e) {
          final FavouriteItemMarkerType itemType;
          final data = state.requireValue;
          if (e == data.work) {
            itemType = FavouriteItemMarkerType.work;
          } else if (e == data.home) {
            itemType = FavouriteItemMarkerType.home;
          } else {
            itemType = FavouriteItemMarkerType.place;
          }
          return DeleteFavouriteItemsRequestItemMapper.fromDomain(e, itemType);
        },
      ),
    );
    print(request.writeToJson());
    state = const AsyncValue.loading();
    final raw = await dio.delete(
      'favourites',
      data: request.writeToBuffer(),
    );
    state = AsyncValue.data(
      proto.FavouritesResponse.fromBuffer(raw.data).toDomain(),
    );
  }

  Future<void> addItem(FavouriteItem item) async {
    await addItems([item]);
  }

  Future<void> setWork(FavouriteItem item) async {
    if (state.asData?.value.work != null) return;
    state = state.whenData((value) => value.copyWith(work: item));
    await addItems([item]);
  }

  Future<void> setHome(FavouriteItem item) async {
    if (state.asData?.value.home != null) return;
    state = state.whenData((value) => value.copyWith(home: item));
    await addItems([item]);
  }

  Future<void> addItems(List<FavouriteItem> items) async {
    ref.read(urbiMetricsProvider.notifier).logEvent("Favorites/addItems", {
      "items": items.map((e) => e.id).toList(),
    });
    mixpanel?.timeEvent("Favorites: addItems");
    final dio = await ref.read(dGisNetworkProvider.future);
    final request = proto.AddFavouriteItemsRequest(items: items.map((e) {
      final FavouriteItemMarkerType itemType;
      final data = state.requireValue;
      if (e == data.work) {
        itemType = FavouriteItemMarkerType.work;
      } else if (e == data.home) {
        itemType = FavouriteItemMarkerType.home;
      } else {
        itemType = FavouriteItemMarkerType.place;
      }
      return AddRequestItemMapper.fromDomain(e, itemType);
    }));
    print(request.toString());
    try {
      final raw = await dio.post(
        'favourites',
        data: request.writeToBuffer(),
      );
      state = AsyncValue.data(
        proto.FavouritesResponse.fromBuffer(raw.data).toDomain(),
      );
    } on DioException catch (e) {
      print(proto.ErrorResponse.fromBuffer(e.response!.data));
    }
    mixpanel?.track("Favorites: addItems");
  }

  @override
  Future<FavouritesState> build() async {
    mixpanel?.timeEvent("Favorites: build");
    final dio = await ref.watch(dGisNetworkProvider.future);
    final raw = await dio.get('favourites');
    final response = proto.FavouritesResponse.fromBuffer(raw.data);
    mixpanel?.track("Favorites: build");
    return response.toDomain();
  }
}
