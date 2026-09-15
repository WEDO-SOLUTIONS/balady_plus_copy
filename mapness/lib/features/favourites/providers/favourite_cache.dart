import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:hive_ce/hive.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/entities/favourites/favourites_state.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/favourites/data/models/favorite_cache_item.dart';
import 'package:mapness/features/favourites/mappers/favorite_cache_item_mapper.dart';
import 'package:mapness/features/favourites/mappers/favourite_item_mapper.dart';
import 'package:mapness/features/favourites/mappers/favourites_response_mapper.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favourite_cache.g.dart';

/// Legacy protobuf-backed favourites cache. Retained ONLY as a one-time, read-only
/// source for migrating existing users' Home/Work/plain favourites into the new
/// `favorite_lists` REST API (see `favorite_lists_migration.dart` and
/// `home_work_favorites_migration.dart`) — nothing should write through this
/// provider anymore. `clear()` is kept for the logout hook in `auth_provider.dart`
/// (a local Hive wipe, not a call to the old API).
final favouriteCacheProvider = _favouriteCacheProvider;

@riverpod
class _FavouriteCache extends _$FavouriteCache {
  static const _boxName = 'favourites';
  static const _keyCache = 'cache';
  static const _keyLastUpdate = 'last_update';
  static const _keyLastUserId = 'last_user_id';

  static const _cacheFor = Duration(minutes: 30);

  DateTime? _lastUpdate;

  bool _isForceRefresh = false;

  bool get isCacheValid => _lastUpdate?.isAfter(DateTime.now().subtract(_cacheFor)) ?? false;

  // Load _lastUpdate from Hive on init
  Future<void> _initLastUpdate() async {
    if (!ref.mounted) {
      return;
    }
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    final stored = favoritesBox.get(_keyLastUpdate) as int?;
    if (stored != null) {
      _lastUpdate = DateTime.fromMillisecondsSinceEpoch(stored);
    }
  }

  // Save _lastUpdate and _lastUserId to Hive when updated
  Future<void> _saveLastUpdate(String? userId) async {
    if (!ref.mounted) {
      return;
    }
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
    if (!ref.mounted) {
      return false;
    }
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
    if (!ref.mounted) {
      return;
    }
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    _lastUpdate = null;
    await favoritesBox.delete(_keyLastUpdate);
    await favoritesBox.delete(_keyLastUserId);
  }

  Future<void> _notifyMapAboutFavourites(FavouritesState data) async {
    if (!ref.mounted) {
      return;
    }
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

  Future<void> _updateState(FavouritesState data) async {
    if (!ref.mounted) {
      return;
    }
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    if (!ref.mounted) {
      return;
    }
    state = AsyncValue.data(data);
    await _notifyMapAboutFavourites(data);
    return favoritesBox.put(_keyCache, data.toHive());
  }

  Future<FavouritesState> _fetchFavourites() async {
    mixpanel?.timeEvent('Favorites: fetchFavourites');
    final dio = await ref.read(dGisNetworkProvider.future);
    final raw = await dio.get('favourites');
    final response = proto.FavouritesResponse.fromBuffer(raw.data as List<int>);
    await mixpanel?.track('Favorites: fetchFavourites');
    return response.toDomain();
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
    if (!ref.mounted) {
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
      if (!ref.mounted) {
        return const FavouritesState(items: []);
      }
      // Also clear the main cache for the new user
      final favoritesBox = await ref.read(hiveProvider(_boxName).future);
      await favoritesBox.delete(_keyCache);
      _lastUpdate = null;
      _isForceRefresh = true;
    } else {
      // Only initialize last update if user hasn't changed
      await _initLastUpdate();
    }
    if (!ref.mounted) {
      return const FavouritesState(items: []);
    }

    final favoritesBox = await ref.read(hiveProvider(_boxName).future);

    FavouritesState result;
    try {
      if (_isForceRefresh || !isCacheValid) {
        logger.log(
          'Fetching favorites from API for user: $currentUserId (forceRefresh: $_isForceRefresh, cacheValid: $isCacheValid)',
          logLevel: MapnessLogLevel.info,
        );
        final apiData = await _fetchFavourites();
        await favoritesBox.put(_keyCache, apiData.toHive());
        _lastUpdate = DateTime.now();
        await _saveLastUpdate(currentUserId);
        await _notifyMapAboutFavourites(apiData);
        result = apiData;
        logger.log('Successfully fetched ${result.items.length} favorites from API', logLevel: MapnessLogLevel.info);
      } else {
        logger.log('Using cached favorites for user: $currentUserId', logLevel: MapnessLogLevel.info);
        result = await getFavouritesStateFromHive();
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
        result = await getFavouritesStateFromHive();
      }
    }

    if (!ref.mounted) {
      return result;
    }
    final link = ref.keepAlive();
    final timer = Timer(_cacheFor, link.close);
    ref.onDispose(timer.cancel);

    return result;
  }

  Future<void> clear() async {
    if (!ref.mounted) {
      return;
    }
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
