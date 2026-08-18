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
import 'package:mapness/features/favourites/helpers/favourite_sync_merge.dart';
import 'package:mapness/features/favourites/mappers/add_request_item.dart';
import 'package:mapness/features/favourites/mappers/delete_favourite_items_request_item_mapper.dart';
import 'package:mapness/features/favourites/mappers/favorite_cache_item_mapper.dart';
import 'package:mapness/features/favourites/mappers/favourite_item_mapper.dart';
import 'package:mapness/features/favourites/mappers/favourites_response_mapper.dart';
import 'package:mapness/features/favourites/providers/favourite_markers.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
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
  static const _keyLastUpdate = 'last_update';
  static const _keyLastUserId = 'last_user_id';

  static const _cacheFor = Duration(minutes: 30);

  /// Write requests (POST/DELETE) get a longer timeout than the shared 5 s of [dGisNetworkProvider]:
  /// a timed-out add is retried by the retry interceptor and shows up as a duplicate on the server.
  static const _writeTimeout = Duration(seconds: 15);

  DateTime? _lastUpdate;

  /// One-shot flags consumed by the next [build]. Set by [forceRefresh] (locale change) or when the user changes.
  bool _isForceRefresh = false;

  /// The pending force refresh is a locale refresh: the server response is merged with the local list
  /// (re-localise titles) instead of replacing it, so items that are missing from the response survive.
  bool _localeRefresh = false;

  bool get isCacheValid => _lastUpdate?.isAfter(DateTime.now().subtract(_cacheFor)) ?? false;

  // Load _lastUpdate from Hive on init
  Future<void> _initLastUpdate() async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    final stored = favoritesBox.get(_keyLastUpdate) as int?;
    if (stored != null) {
      _lastUpdate = DateTime.fromMillisecondsSinceEpoch(stored);
    }
  }

  // Save _lastUpdate and _lastUserId to Hive when updated
  Future<void> _saveLastUpdate(String? userId) async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    if (_lastUpdate != null) {
      await favoritesBox.put(_keyLastUpdate, _lastUpdate!.millisecondsSinceEpoch);
    }
    if (userId != null) {
      await favoritesBox.put(_keyLastUserId, userId);
    }
  }

  // Check if user has changed
  Future<bool> _hasUserChanged(String? currentUserId) async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    final storedUserId = favoritesBox.get(_keyLastUserId) as String?;

    // If no stored user or user is different, cache is invalid
    if (storedUserId == null || storedUserId != currentUserId) {
      return true;
    }
    return false;
  }

  // Clear cache when user changes
  Future<void> _clearCacheForUserChange() async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    _lastUpdate = null;
    await favoritesBox.delete(_keyLastUpdate);
    await favoritesBox.delete(_keyLastUserId);
    // Also clear the sync queues to avoid syncing old user's data
    await favoritesBox.delete(_keyAddSync);
    await favoritesBox.delete(_keyDeleteSync);
  }

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

    try {
      await _deleteRequest(items: items, workId: oldDataState.work?.id, homeId: oldDataState.home?.id);
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
      await _deleteRequest(items: [item], workId: oldDataState.work?.id, homeId: oldDataState.home?.id);

      ref.invalidate(favouriteMarkersProvider);
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

    final filteredItems = oldItems.where((element) => !items.any((e) => e.id == element.id)).toList();

    final newState = FavouritesState(items: filteredItems, work: work, home: home);

    await _updateState(newState);

    try {
      await _deleteRequest(items: items, workId: oldDataState.work?.id, homeId: oldDataState.home?.id);
    } on Exception catch (_) {
      await _addToDeletionSync(items);
    }
  }

  Future<void> _addToDeletionSync(List<FavouriteItem> items) async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    final deleteSync =
        (await favoritesBox.get(_keyDeleteSync, defaultValue: <FavoriteCacheItem>[]) as List<dynamic>)
            .cast<FavoriteCacheItem>()
          ..addAll(items.map((e) => e.toHive()));

    await favoritesBox.put(_keyDeleteSync, deleteSync);
  }

  Future<void> _addToAddSync(FavouriteItem item) async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    final addSync =
        (await favoritesBox.get(_keyAddSync, defaultValue: <FavoriteCacheItem>[]) as List<dynamic>)
            .cast<FavoriteCacheItem>()
          ..add(item.toHive());

    await favoritesBox.put(_keyAddSync, addSync);
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

    try {
      await _addItemsRequest(items: [item], workId: state.work?.id, homeId: state.home?.id);
    } on Exception catch (_) {
      await _addToAddSync(item);
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
      final deleteSync = (favoritesBox.get(_keyDeleteSync, defaultValue: <FavoriteCacheItem>[]) as List<dynamic>)
          .cast<FavoriteCacheItem>();

      if (deleteSync.isNotEmpty) {
        await _deleteRequest(items: deleteSync.map((e) => e.toDomain()).toList(), workId: workId, homeId: homeId);
        await favoritesBox.delete(_keyDeleteSync);
      }
    } on Object catch (_) {
      logger.log('Delete sync failed', logLevel: MapnessLogLevel.critical);
    }

    try {
      final addSync = (favoritesBox.get(_keyAddSync, defaultValue: <FavoriteCacheItem>[]) as List<dynamic>)
          .cast<FavoriteCacheItem>();

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
    await dio.delete(
      'favourites',
      data: request.writeToBuffer(),
      options: Options(sendTimeout: _writeTimeout, receiveTimeout: _writeTimeout),
    );
  }

  Future<void> _addItemsRequest({
    required List<FavouriteItem> items,
    required String? workId,
    required String? homeId,
  }) async {
    mixpanel?.timeEvent('Favorites: addItems');
    final dio = await ref.read(dGisNetworkProvider.future);
    final request = proto.AddFavouriteItemsRequest(
      items: items.map((e) {
        final itemType = _getItemType(e.id, workId, homeId);
        return AddRequestItemMapper.fromDomain(e, itemType);
      }),
    );
    try {
      final raw = await dio.post(
        'favourites',
        data: request.writeToBuffer(),
        options: Options(sendTimeout: _writeTimeout, receiveTimeout: _writeTimeout),
      );
      final newState = proto.FavouritesResponse.fromBuffer(raw.data as List<int>).toDomain();
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

  /// Re-fetches favourites after a locale change so cached titles get re-localised.
  ///
  /// Schedules a regular rebuild instead of calling [build] by hand (which ran a second, detached build whose result
  /// was thrown away while its side effect — `cache` overwritten by the server response — stayed). The rebuild merges
  /// the response with the local list, see [_localeRefresh].
  Future<void> forceRefresh() async {
    _isForceRefresh = true;
    _localeRefresh = true;
    ref.invalidateSelf();
  }

  /// Overlays the not-yet-synced queues on top of [state] for display: pending additions that the server does not
  /// know about yet stay visible, pending deletions stay hidden. The Hive `cache` itself is not touched — it keeps
  /// mirroring the server (or the merged locale-refresh) list; the queues are applied on every read.
  Future<FavouritesState> _applyPendingSync(FavouritesState state, {required FavouritesState local}) async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    final addSync = (favoritesBox.get(_keyAddSync, defaultValue: <FavoriteCacheItem>[]) as List<dynamic>)
        .cast<FavoriteCacheItem>();
    final deleteSync = (favoritesBox.get(_keyDeleteSync, defaultValue: <FavoriteCacheItem>[]) as List<dynamic>)
        .cast<FavoriteCacheItem>();
    if (addSync.isEmpty && deleteSync.isEmpty) {
      return state;
    }

    return applyPendingFavouriteSync(
      state,
      pendingAdd: addSync.map((e) => e.toDomain()).toList(),
      pendingDelete: deleteSync.map((e) => e.toDomain()).toList(),
      // The queues do not carry the item type; like [_sync], resolve home/work from the local list.
      homeKey: local.home == null ? null : favouriteItemKey(local.home!),
      workKey: local.work == null ? null : favouriteItemKey(local.work!),
    );
  }

  @override
  Future<FavouritesState> build() async {
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
      return const FavouritesState(items: []);
    }

    //  'idNo' from auth state
    final currentUserId = authState.idNo ?? '';

    // Check if user has changed BEFORE initializing last update
    final userHasChanged = await _hasUserChanged(currentUserId);
    if (userHasChanged) {
      logger.log(
        'User changed from previous session, clearing all favorites cache for user: $currentUserId',
        logLevel: MapnessLogLevel.info,
      );
      await _clearCacheForUserChange();
      // Also clear the main cache for the new user
      final favoritesBox = await ref.read(hiveProvider(_boxName).future);
      await favoritesBox.delete(_keyCache);
      _lastUpdate = null;
    } else {
      // Only initialize last update if user hasn't changed
      await _initLastUpdate();
    }

    // sync uncommitted changes
    await _sync();

    final favoritesBox = await ref.read(hiveProvider(_boxName).future);

    // Consume the one-shot flags now: a forceRefresh() that lands while this build is in flight sets them again
    // and schedules another rebuild, which picks them up. A user change always means a plain (non-merge) fetch —
    // the local cache has just been dropped.
    final forceRefresh = _isForceRefresh || userHasChanged;
    final mergeWithLocal = _localeRefresh && !userHasChanged;
    _isForceRefresh = false;
    _localeRefresh = false;

    // Local list as it was before this build touched the network (post-sync): the base for the locale-refresh merge
    // and the source of home/work identity for the pending-sync overlay.
    final localState = await getFavouritesStateFromHive();

    FavouritesState result;
    try {
      if (forceRefresh || !isCacheValid) {
        logger.log(
          'Fetching favorites from API for user: $currentUserId (forceRefresh: $forceRefresh, mergeWithLocal: $mergeWithLocal, cacheValid: $isCacheValid)',
          logLevel: MapnessLogLevel.info,
        );
        final apiData = await _fetchFavourites();
        // A locale refresh is about re-localising what the user already has, not about reconciling with the
        // server: keep local items the response lacks (freshly added ones may not be visible server-side yet).
        final cacheData = mergeWithLocal ? mergeFavouritesWithLocal(server: apiData, local: localState) : apiData;
        await favoritesBox.put(_keyCache, cacheData.toHive());
        _lastUpdate = DateTime.now();
        await _saveLastUpdate(currentUserId);
        result = await _applyPendingSync(cacheData, local: localState);
        await _notifyMapAboutFavourites(result);
        logger.log('Successfully fetched ${apiData.items.length} favorites from API', logLevel: MapnessLogLevel.info);
      } else {
        logger.log('Using cached favorites for user: $currentUserId', logLevel: MapnessLogLevel.info);
        result = await _applyPendingSync(localState, local: localState);
      }
    } on Exception catch (e) {
      logger.log('Error fetching favorites: $e', logLevel: MapnessLogLevel.critical);
      // If user just changed, return empty state instead of stale cached data
      if (userHasChanged) {
        result = const FavouritesState(items: []);
        logger.log(
          'User changed but failed to fetch favorites from API, returning empty state',
          logLevel: MapnessLogLevel.warning,
        );
      } else {
        // For existing users, fall back to cache
        result = await _applyPendingSync(localState, local: localState);
      }
    }

    final link = ref.keepAlive();
    final timer = Timer(_cacheFor, link.close);
    ref.onDispose(timer.cancel);

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
