import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/domain/favourites_state.dart';
import 'package:mapness/_features/favourites/entity/models/favorite_cache_item.dart';
import 'package:mapness/_features/favourites/mappers/add_request_item.dart';
import 'package:mapness/_features/favourites/mappers/delete_favourite_items_request_item_mapper.dart';
import 'package:mapness/_features/favourites/mappers/favorite_cache_item_mapper.dart';
import 'package:mapness/_features/favourites/mappers/favourites_response_mapper.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favourite_cache.g.dart';

final favouriteCacheProvider = _favouriteCacheProvider;

@riverpod
class _FavouriteCache extends _$FavouriteCache {
  static const _boxName = 'favourites';
  static const _keyCache = 'cache';
  static const _keyDeleteSync = 'delete_sync';
  static const _keyAddSync = 'add_sync';

  static const _tag = MetricsConstants.favoriteTag;

  final _cacheFor = const Duration(minutes: 30);

  DateTime? _lastUpdate;

  bool get isCacheValid =>
      _lastUpdate?.isAfter(DateTime.now().subtract(_cacheFor)) ?? false;

  Future<void> deleteAll() async {
    if (!state.hasValue) {
      return;
    }

    final oldDataState = state.requireValue;

    final items = [
      ...oldDataState.items,
      if (oldDataState.home != null) oldDataState.home!,
      if (oldDataState.work != null) oldDataState.work!,
    ];

    const newState = FavouritesState(items: []);
    await _updateState(newState);

    try {
      await _deleteRequest(
        items: items,
        workId: oldDataState.work?.id,
        homeId: oldDataState.home?.id,
      );
    } on Exception catch (_) {
      await _addToDeletionSync(items);
    }
  }

  Future<void> deleteItem(FavouriteItem item) async {
    if (!state.hasValue) {
      return;
    }
    final oldDataState = state.requireValue;
    final items = oldDataState.items;
    final work = oldDataState.work;
    final home = oldDataState.home;

    final newState = FavouritesState(
      items: items.where((e) => e.id != item.id).toList(),
      work: item.id == work?.id ? null : work,
      home: item.id == home?.id ? null : home,
    );

    await _updateState(newState);

    try {
      await _deleteRequest(
        items: [item],
        workId: oldDataState.work?.id,
        homeId: oldDataState.home?.id,
      );
    } on Exception catch (_) {
      await _addToDeletionSync([item]);
    }
  }

  Future<void> deleteItems(List<FavouriteItem> items) async {
    if (!state.hasValue) {
      return;
    }

    final oldDataState = state.requireValue;
    final oldItems = oldDataState.items;
    final work = oldDataState.work;
    final home = oldDataState.home;

    oldItems.removeWhere((element) => items.any((e) => e.id == element.id));

    final newState = FavouritesState(
      items: oldItems,
      work: work,
      home: home,
    );

    await _updateState(newState);

    try {
      await _deleteRequest(
        items: items,
        workId: oldDataState.work?.id,
        homeId: oldDataState.home?.id,
      );
    } on Exception catch (_) {
      await _addToDeletionSync(items);
    }
  }

  Future<void> _addToDeletionSync(List<FavouriteItem> items) async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    final deleteSync = (await favoritesBox.get(_keyDeleteSync, defaultValue: [])
            as List<dynamic>)
        .cast<FavoriteCacheItem>()
      ..addAll(items.map((e) => e.toHive()));

    await favoritesBox.put(_keyDeleteSync, deleteSync);
  }

  Future<void> setHome(FavouriteItem item) async {
    if (!state.hasValue) {
      return;
    }
    if (state.requireValue.items.any((element) => element.id == item.id) ||
        state.requireValue.work?.id == item.id) {
      await deleteItem(item);
    }

    final newState = state.requireValue.copyWith(home: item);
    await _addItem(item, newState);
  }

  Future<void> setWork(FavouriteItem item) async {
    if (!state.hasValue) {
      return;
    }
    if (state.requireValue.items.any((element) => element.id == item.id) ||
        state.requireValue.home?.id == item.id) {
      await deleteItem(item);
    }

    final newState = state.requireValue.copyWith(work: item);
    await _addItem(item, newState);
  }

  Future<void> addItem(FavouriteItem item) async {
    if (!state.hasValue) {
      return;
    }
    if (state.requireValue.work?.id == item.id ||
        state.requireValue.home?.id == item.id) {
      await deleteItem(item);
    }

    final newState =
        state.requireValue.copyWith(items: [...state.requireValue.items, item]);
    await _addItem(item, newState);
  }

  FavouriteItem? getFavouriteOrNull(int objectId) {
    if (!state.hasValue) {
      return null;
    }

    final favouriteState = state.requireValue;

    final items = [
      ...favouriteState.items,
      favouriteState.home,
      favouriteState.work,
    ];

    return items.firstWhereOrNull(
        (element) => element?.entity?.id == objectId.toString());
  }

  bool isFavourite(int objectId) {
    if (!state.hasValue) {
      return false;
    }

    final favouriteState = state.requireValue;

    final items = [
      ...favouriteState.items,
      favouriteState.home,
      favouriteState.work,
    ];

    return items.any((element) => element?.entity?.id == objectId.toString());
  }

  Future<void> _addItem(
    FavouriteItem item,
    FavouritesState state,
  ) async {
    await _updateState(state);

    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    try {
      await _addItemsRequest(
        items: [item],
        workId: state.work?.id,
        homeId: state.home?.id,
      );
    } on Exception catch (_) {
      await favoritesBox.put(_keyAddSync, item.toHive());
    }
  }

  Future<void> _updateState(FavouritesState data) async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    state = AsyncValue.data(data);
    return favoritesBox.put(_keyCache, data.toHive());
  }

  Future<void> _sync() async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    final cache = favoritesBox.get(_keyCache,
        defaultValue: FavoriteCacheState()) as FavoriteCacheState?;
    final workId = cache?.work?.toDomain().id;
    final homeId = cache?.home?.toDomain().id;

    try {
      final deleteSync = (await favoritesBox
              .get(_keyDeleteSync, defaultValue: []) as List<dynamic>)
          .cast<FavoriteCacheItem>();

      if (deleteSync.isNotEmpty) {
        await _deleteRequest(
          items: deleteSync.map((e) => e.toDomain()).toList(),
          workId: workId,
          homeId: homeId,
        );
        await favoritesBox.delete(_keyDeleteSync);
      }
    } on Exception catch (_) {
      debugPrint('Delete sync failed');
    }

    try {
      final addSync = (await favoritesBox.get(_keyAddSync, defaultValue: [])
              as List<dynamic>)
          .cast<FavoriteCacheItem>();

      if (addSync.isNotEmpty) {
        await _addItemsRequest(
          items: addSync.map((e) => e.toDomain()).toList(),
          workId: workId,
          homeId: homeId,
        );
        await favoritesBox.delete(_keyAddSync);
      }
    } on Exception catch (_) {
      debugPrint('Add sync failed');
    }
  }

  Future<void> _deleteRequest({
    required List<FavouriteItem> items,
    required String? workId,
    required String? homeId,
  }) async {
    final dio = await ref.read(dGisNetworkProvider.future);
    final request = proto.DeleteFavouriteItemsRequest(
      items: items.map(
        (e) {
          final FavouriteItemMarkerType itemType;
          if (e.id == workId) {
            itemType = FavouriteItemMarkerType.work;
          } else if (e.id == homeId) {
            itemType = FavouriteItemMarkerType.home;
          } else {
            itemType = FavouriteItemMarkerType.place;
          }
          return DeleteFavouriteItemsRequestItemMapper.fromDomain(e, itemType);
        },
      ),
    );
    Metrics.logEventAdvanced(
      MetricsConstants.favoritesKeys.deleteItems,
      group: _tag,
      props: {
        'items': items.map((e) => e.id).toList(),
      },
    );
    await dio.delete('favourites', data: request.writeToBuffer());
  }

  Future<void> _addItemsRequest({
    required List<FavouriteItem> items,
    required String? workId,
    required String? homeId,
  }) async {
    Metrics.logEventAdvanced(
      MetricsConstants.favoritesKeys.addItems,
      group: _tag,
      props: {
        'items': items.map((e) => e.id).toList(),
      },
    );
    mixpanel?.timeEvent('Favorites: addItems');
    final dio = await ref.read(dGisNetworkProvider.future);
    final request = proto.AddFavouriteItemsRequest(
      items: items.map((e) {
        final FavouriteItemMarkerType itemType;
        if (e.id == workId) {
          itemType = FavouriteItemMarkerType.work;
        } else if (e.id == homeId) {
          itemType = FavouriteItemMarkerType.home;
        } else {
          itemType = FavouriteItemMarkerType.place;
        }
        return AddRequestItemMapper.fromDomain(e, itemType);
      }),
    );
    try {
      final raw = await dio.post('favourites', data: request.writeToBuffer());
      final newState =
          proto.FavouritesResponse.fromBuffer(raw.data as List<int>).toDomain();
      await _updateState(newState);
    } on DioException catch (e) {
      debugPrint(proto.ErrorResponse.fromBuffer(e.response!.data as List<int>)
          .toString());
    }
    mixpanel?.track('Favorites: addItems');
  }

  Future<FavouritesState> _fetchFavourites() async {
    mixpanel?.timeEvent('Favorites: fetchFavourites');
    final dio = await ref.watch(dGisNetworkProvider.future);
    final raw = await dio.get('favourites');
    final response = proto.FavouritesResponse.fromBuffer(raw.data as List<int>);
    mixpanel?.track('Favorites: fetchFavourites');
    return response.toDomain();
  }

  @override
  Future<FavouritesState> build() async {
    final authState = await ref.watch(authProvider.future);
    if (authState == null) {
      return const FavouritesState(items: []);
    }

    final link = ref.keepAlive();
    final timer = Timer(_cacheFor, link.close);

    ref.onDispose(() => timer.cancel);

    // sync uncommitted changes
    await _sync();

    final favoritesBox = await ref.read(hiveProvider(_boxName).future);

    try {
      if (!isCacheValid) {
        final apiData = await _fetchFavourites();
        await favoritesBox.put(_keyCache, apiData.toHive());
        _lastUpdate = DateTime.now();
        return apiData;
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    final cache = favoritesBox.get(_keyCache,
        defaultValue: FavoriteCacheState()) as FavoriteCacheState?;

    final homeItem = cache?.home;
    final workItem = cache?.work;
    final placesList = cache?.places;

    return FavouritesState(
      home: homeItem?.toDomain(),
      work: workItem?.toDomain(),
      items: placesList?.map((e) => e.toDomain()).toList() ?? [],
    );
  }
}
