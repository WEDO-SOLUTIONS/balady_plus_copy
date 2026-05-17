import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:hive_ce/hive.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/entities/favourites/favourites_state.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/favourites/data/models/favorite_cache_item.dart';
import 'package:mapness/features/favourites/helpers/favourite_entity_id.dart';
import 'package:mapness/features/favourites/mappers/add_request_item.dart';
import 'package:mapness/features/favourites/mappers/delete_favourite_items_request_item_mapper.dart';
import 'package:mapness/features/favourites/mappers/favorite_cache_item_mapper.dart';
import 'package:mapness/features/favourites/mappers/favourite_item_mapper.dart';
import 'package:mapness/features/favourites/mappers/favourites_response_mapper.dart';
import 'package:mapness/features/favourites/providers/favourite_markers.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
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

  static const _cacheFor = Duration(minutes: 30);

  DateTime? _lastUpdate;

  bool _isForceRefresh = false;

  bool get isCacheValid => _lastUpdate?.isAfter(DateTime.now().subtract(_cacheFor)) ?? false;

  bool _isEmpty(FavouritesState data) => data.home == null && data.work == null && data.items.isEmpty;

  List<String> _missingIds(FavouritesState data, List<FavouriteItem> items) {
    final ids = {
      data.home?.id,
      data.work?.id,
      ...data.items.map((item) => item.id),
    };

    return items.map((item) => item.id).where((id) => !ids.contains(id)).toList();
  }

  FavouritesState _readCache(Box<dynamic> favoritesBox) {
    final cache = favoritesBox.get(_keyCache, defaultValue: FavoriteCacheState()) as FavoriteCacheState?;
    return cache?.toDomain() ?? const FavouritesState(items: []);
  }

  List<FavoriteCacheItem> _readSyncItems(Box<dynamic> favoritesBox, String key) {
    final rawItems = favoritesBox.get(key, defaultValue: <FavoriteCacheItem>[]);
    if (rawItems is! List) {
      return [];
    }

    return rawItems.cast<FavoriteCacheItem>();
  }

  bool _hasPendingSync(Box<dynamic> favoritesBox) =>
      _readSyncItems(favoritesBox, _keyDeleteSync).isNotEmpty || _readSyncItems(favoritesBox, _keyAddSync).isNotEmpty;

  List<FavouriteItem?> _getAllItems(FavouritesState favouriteState) => [
    ...favouriteState.items,
    favouriteState.home,
    favouriteState.work,
  ];

  FavouriteItemMarkerType _getItemType(String itemId, String? workId, String? homeId) {
    if (itemId == workId) {
      return FavouriteItemMarkerType.work;
    } else if (itemId == homeId) {
      return FavouriteItemMarkerType.home;
    } else {
      return FavouriteItemMarkerType.place;
    }
  }

  Future<void> _notifyMapAboutFavourites(FavouritesState data) async {
    try {
      final controller = await ref
          .read(dgisControllerProvider.future)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw TimeoutException('DgisController initialization timeout'),
          );
      await controller.favouritesUpdateNotification(
        FavouritesStateMessage(
          home: data.home?.message,
          work: data.work?.message,
          items: data.items.map((item) => item.message).toList(),
        ),
      );
    } on Exception catch (e) {
      logger.log('Failed to notify map about favourites update: $e', logLevel: MapnessLogLevel.warning);
    }
  }

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
    await _removeFromAddSync(items);
    await _addToDeletionSync(items);

    try {
      await _deleteRequest(items: items, workId: oldDataState.work?.id, homeId: oldDataState.home?.id);
      await _removeFromDeletionSync(items);
    } on Exception catch (_) {
      // Keep delete_sync queued for the next app start.
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
    await _removeFromAddSync([item]);
    await _addToDeletionSync([item]);

    try {
      await _deleteRequest(items: [item], workId: oldDataState.work?.id, homeId: oldDataState.home?.id);
      await _removeFromDeletionSync([item]);

      ref.invalidate(favouriteMarkersProvider);
    } on Exception catch (_) {
      // Keep delete_sync queued for the next app start.
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

    final filteredItems = oldItems.where((element) => !items.any((e) => e.id == element.id)).toList();

    final newState = FavouritesState(items: filteredItems, work: work, home: home);

    await _updateState(newState);
    await _removeFromAddSync(items);
    await _addToDeletionSync(items);

    try {
      await _deleteRequest(items: items, workId: oldDataState.work?.id, homeId: oldDataState.home?.id);
      await _removeFromDeletionSync(items);
    } on Exception catch (_) {
      // Keep delete_sync queued for the next app start.
    }
  }

  Future<void> _addToDeletionSync(List<FavouriteItem> items) async {
    await _addToSyncQueue(key: _keyDeleteSync, items: items);
  }

  Future<void> _addToAddSync(FavouriteItem item) async {
    await _addToSyncQueue(key: _keyAddSync, items: [item]);
  }

  Future<void> _addToSyncQueue({required String key, required List<FavouriteItem> items}) async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    final byId = {
      for (final item in _readSyncItems(favoritesBox, key)) item.id: item,
    };

    for (final item in items) {
      byId[item.id] = item.toHive();
    }

    await favoritesBox.put(key, byId.values.toList());
  }

  Future<void> _removeFromAddSync(List<FavouriteItem> items) async {
    await _removeFromSyncQueue(key: _keyAddSync, items: items);
  }

  Future<void> _removeFromDeletionSync(List<FavouriteItem> items) async {
    await _removeFromSyncQueue(key: _keyDeleteSync, items: items);
  }

  Future<void> _removeFromSyncQueue({required String key, required List<FavouriteItem> items}) async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    final ids = items.map((e) => e.id).toSet();
    final updated = _readSyncItems(favoritesBox, key).where((item) => !ids.contains(item.id)).toList();

    if (updated.isEmpty) {
      await favoritesBox.delete(key);
    } else {
      await favoritesBox.put(key, updated);
    }
  }

  Future<void> setHome(FavouriteItem item) async {
    if (!state.hasValue) {
      return;
    }
    if (state.requireValue.items.any((element) => element.id == item.id) || state.requireValue.work?.id == item.id) {
      await deleteItem(item);
    }

    final newState = state.requireValue.copyWith(home: item);
    await _addItem(item, newState);
  }

  Future<void> setWork(FavouriteItem item) async {
    if (!state.hasValue) {
      return;
    }
    if (state.requireValue.items.any((element) => element.id == item.id) || state.requireValue.home?.id == item.id) {
      await deleteItem(item);
    }

    final newState = state.requireValue.copyWith(work: item);
    await _addItem(item, newState);
  }

  Future<void> addItem(FavouriteItem item) async {
    if (!state.hasValue) {
      return;
    }
    if (state.requireValue.work?.id == item.id || state.requireValue.home?.id == item.id) {
      await deleteItem(item);
    }

    final newState = state.requireValue.copyWith(items: [...state.requireValue.items, item]);
    await _addItem(item, newState);
  }

  FavouriteItem? getFavouriteOrNull(int objectId) {
    if (!state.hasValue) {
      return null;
    }

    final favouriteState = state.requireValue;
    final items = _getAllItems(favouriteState);

    return items.firstWhereOrNull((element) => parseObjectIdFromFavouriteEntityId(element?.entity?.id) == objectId);
  }

  bool isFavourite(int objectId) {
    if (!state.hasValue) {
      return false;
    }

    final favouriteState = state.requireValue;
    final items = _getAllItems(favouriteState);

    return items.any((element) => parseObjectIdFromFavouriteEntityId(element?.entity?.id) == objectId);
  }

  Future<void> _addItem(FavouriteItem item, FavouritesState state) async {
    await _updateState(state);
    await _addToAddSync(item);

    try {
      await _addItemsRequest(items: [item], workId: state.work?.id, homeId: state.home?.id);
      await _removeFromAddSync([item]);
    } on Exception catch (_) {
      // Keep add_sync queued for the next app start.
    }
  }

  Future<void> _updateState(FavouritesState data) async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    state = AsyncValue.data(data);
    await _notifyMapAboutFavourites(data);
    return favoritesBox.put(_keyCache, data.toHive());
  }

  Future<void> _sync() async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    final cache = favoritesBox.get(_keyCache, defaultValue: FavoriteCacheState()) as FavoriteCacheState?;
    final workId = cache?.work?.toDomain().id;
    final homeId = cache?.home?.toDomain().id;

    try {
      final deleteSync = _readSyncItems(favoritesBox, _keyDeleteSync);

      if (deleteSync.isNotEmpty) {
        await _deleteRequest(items: deleteSync.map((e) => e.toDomain()).toList(), workId: workId, homeId: homeId);
        await favoritesBox.delete(_keyDeleteSync);
      }
    } on Object catch (_) {
      logger.log('Delete sync failed', logLevel: MapnessLogLevel.critical);
    }

    try {
      final addSync = _readSyncItems(favoritesBox, _keyAddSync);

      if (addSync.isNotEmpty) {
        await _addItemsRequest(items: addSync.map((e) => e.toDomain()).toList(), workId: workId, homeId: homeId);
        await favoritesBox.delete(_keyAddSync);
      }
    } on Object catch (_) {
      logger.log('Add sync failed', logLevel: MapnessLogLevel.critical);
    }
  }

  Future<void> _deleteRequest({
    required List<FavouriteItem> items,
    required String? workId,
    required String? homeId,
  }) async {
    final dio = await ref.read(dGisNetworkProvider.future);
    final request = proto.DeleteFavouriteItemsRequest(
      items: items.map((e) {
        final itemType = _getItemType(e.id, workId, homeId);
        return DeleteFavouriteItemsRequestItemMapper.fromDomain(e, itemType);
      }),
    );
    Metrics.logEventAdvanced(
      MetricsConstants.favoritesKeys.deleteItems,
      group: _tag,
      props: {'items': items.map((e) => e.id).toList()},
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
      props: {'items': items.map((e) => e.id).toList()},
    );
    mixpanel?.timeEvent('Favorites: addItems');
    final dio = await ref.read(dGisNetworkProvider.future);
    final request = proto.AddFavouriteItemsRequest(
      items: items.map((e) {
        final itemType = _getItemType(e.id, workId, homeId);
        return AddRequestItemMapper.fromDomain(e, itemType);
      }),
    );
    try {
      final raw = await dio.post('favourites', data: request.writeToBuffer());
      final newState = proto.FavouritesResponse.fromBuffer(raw.data as List<int>).toDomain();
      final missingIds = _missingIds(newState, items);
      if (missingIds.isNotEmpty) {
        final message = 'Add favourites response misses added items $missingIds; keeping local cache';
        logger.log(
          message,
          logLevel: MapnessLogLevel.warning,
        );
        throw StateError(message);
      }
      await _updateState(newState);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        logger.log(
          proto.ErrorResponse.fromBuffer(e.response!.data as List<int>).toString(),
          logLevel: MapnessLogLevel.critical,
        );
      } else {
        logger.log(
          'Add favourites request failed: ${e.message}',
          logLevel: MapnessLogLevel.critical,
        );
      }
      rethrow;
    }
    await mixpanel?.track('Favorites: addItems');
  }

  Future<FavouritesState> _fetchFavourites() async {
    mixpanel?.timeEvent('Favorites: fetchFavourites');
    final dio = await ref.watch(dGisNetworkProvider.future);
    final raw = await dio.get('favourites');
    final response = proto.FavouritesResponse.fromBuffer(raw.data as List<int>);
    await mixpanel?.track('Favorites: fetchFavourites');
    return response.toDomain();
  }

  Future<void> forceRefresh() async {
    _isForceRefresh = true;
    try {
      await build();
    } catch (_) {}
    _isForceRefresh = false;
  }

  @override
  Future<FavouritesState> build() async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    final localState = _readCache(favoritesBox);

    final authState = await ref
        .watch(authProvider.future)
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            logger.log('Auth provider timeout in favourites', logLevel: MapnessLogLevel.warning);
            return null;
          },
        );
    if (authState == null) {
      return localState;
    }

    // sync uncommitted changes
    await _sync();
    final hasPendingSync = _hasPendingSync(favoritesBox);

    FavouritesState result;
    try {
      if (_isForceRefresh || !isCacheValid) {
        final apiData = await _fetchFavourites();
        if (hasPendingSync && !_isEmpty(localState) && _isEmpty(apiData)) {
          logger.log(
            'Skipping empty favourites response because local cache has data and pending sync exists',
            logLevel: MapnessLogLevel.warning,
          );
          result = localState;
        } else {
          await favoritesBox.put(_keyCache, apiData.toHive());
          _lastUpdate = DateTime.now();
          await _notifyMapAboutFavourites(apiData);
          result = apiData;
        }
      } else {
        result = localState;
      }
    } on Exception catch (e) {
      logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
      result = localState;
    }

    final link = ref.keepAlive();
    final timer = Timer(_cacheFor, link.close);
    ref.onDispose(() => timer.cancel);

    return result;
  }

  Future<void> clear() async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    await favoritesBox.clear();
    const newState = FavouritesState(items: []);
    await _updateState(newState);
  }
}

Future<FavouritesState> getFavouritesStateFromHive() async {
  final favoritesBox = await Hive.openBox(_FavouriteCache._boxName);
  final cache = favoritesBox.get(_FavouriteCache._keyCache, defaultValue: FavoriteCacheState()) as FavoriteCacheState?;
  final homeItem = cache?.home;
  final workItem = cache?.work;
  final placesList = cache?.places;

  return FavouritesState(
    home: homeItem?.toDomain(),
    work: workItem?.toDomain(),
    items: placesList?.map((e) => e.toDomain()).toList() ?? [],
  );
}
