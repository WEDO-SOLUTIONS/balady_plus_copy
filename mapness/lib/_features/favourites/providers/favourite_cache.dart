import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/domain/favourites_state.dart';
import 'package:mapness/_features/favourites/entity/models/favorite_cache_item.dart';
import 'package:mapness/_features/favourites/mappers/favorite_cache_item_mapper.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'favourite_repository.dart';

part 'favourite_cache.g.dart';

@riverpod
class FavouriteCache extends _$FavouriteCache {
  static const _boxName = 'favourites';
  static const _keyHomeWork = 'cache';
  static const _keyDeleteSync = 'delete_sync';
  static const _keyAddSync = 'add_sync';

  final _cacheFor = const Duration(minutes: 30);

  DateTime? _lastUpdate;

  bool get isCacheValid =>
      _lastUpdate?.isAfter(DateTime.now().subtract(_cacheFor)) ?? false;

  Future<void> deleteItem(FavouriteItem item) async {
    late FavouritesState data;
    state.whenData((value) async {
      if (value.home == item) {
        data = FavouritesState(
          items: value.items,
          work: value.work,
        );
      } else if (value.work == item) {
        data = FavouritesState(
          items: value.items,
          home: value.home,
        );
      } else {
        final newItems = value.items.where((e) => e != item).toList();
        data = FavouritesState(
          items: newItems,
          work: value.work,
          home: value.home,
        );
      }

      state = AsyncValue.data(data);

      final favoritesBox = await ref.read(hiveProvider(_boxName).future);
      await favoritesBox.put(_keyHomeWork, data.toHive());

      try {
        await ref.read(favouriteRepositoryProvider.notifier).delete(item);
      } on Exception catch (_) {
        final deleteSync = await favoritesBox.get(_keyDeleteSync,
            defaultValue: <FavoriteCacheItem>[]) as List<FavoriteCacheItem>
          ..add(item.toHive());

        await favoritesBox.put(_keyDeleteSync, deleteSync);
      }
    });
  }

  Future<void> setHome(FavouriteItem item) async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    state.whenData((value) async {
      if (value.home != null) {
        await deleteItem(value.home!);
      }
      final newData = FavouritesState(
        items: value.items,
        work: value.work,
        home: item,
      );

      state = AsyncValue.data(newData);

      final favoritesBox = await ref.read(hiveProvider(_boxName).future);
      await favoritesBox.put(_keyHomeWork, newData.toHive());
    });

    try {
      await ref.read(favouriteRepositoryProvider.notifier).setHome(item);
    } on Exception catch (_) {
      await favoritesBox.put(_keyAddSync, item.toHive());
    }
  }

  Future<void> setWork(FavouriteItem item) async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    state.whenData((value) async {
      if (value.work != null) {
        await deleteItem(value.work!);
      }
      final newData = FavouritesState(
        items: value.items,
        work: item,
        home: value.home,
      );

      state = AsyncValue.data(newData);

      await favoritesBox.put(_keyHomeWork, newData.toHive());
    });

    try {
      await ref.read(favouriteRepositoryProvider.notifier).setWork(item);
    } on Exception catch (_) {
      await favoritesBox.put(_keyAddSync, item.toHive());
    }
  }

  Future<void> addItem(FavouriteItem item) async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    state.whenData((value) async {
      await deleteItem(item);
      final newData = FavouritesState(
        items: [...value.items, item],
        work: value.work,
        home: value.home,
      );

      state = AsyncValue.data(newData);

      await favoritesBox.put(_keyHomeWork, newData.toHive());
    });

    try {
      await ref.read(favouriteRepositoryProvider.notifier).addItem(item);
    } on Exception catch (_) {
      await favoritesBox.put(_keyAddSync, item.toHive());
    }
  }

  Future<void> _sync() async {
    final favoritesBox = await ref.read(hiveProvider(_boxName).future);
    try {
      final deleteSync = await favoritesBox.get(_keyDeleteSync,
          defaultValue: <FavoriteCacheItem>[]) as List<FavoriteCacheItem>;

      if (deleteSync.isEmpty) {
        return;
      }

      await ref
          .read(favouriteRepositoryProvider.notifier)
          .deleteMany(deleteSync.map((e) => e.toDomain()).toList());
      await favoritesBox.delete(_keyDeleteSync);
    } on Exception catch (_) {
      debugPrint('Delete sync failed');
    }

    try {
      final addSync = await favoritesBox.get(_keyAddSync,
          defaultValue: <FavoriteCacheItem>[]) as List<FavoriteCacheItem>;

      if (addSync.isEmpty) {
        return;
      }

      await ref
          .read(favouriteRepositoryProvider.notifier)
          .addItems(addSync.map((e) => e.toDomain()).toList());
      await favoritesBox.delete(_keyAddSync);
    } on Exception catch (_) {
      debugPrint('Add sync failed');
    }
  }

  @override
  Future<FavouritesState> build() async {
    final link = ref.keepAlive();
    final timer = Timer(_cacheFor, link.close);
    ref.onDispose(() => timer.cancel);

    await _sync();

    final favoritesBox = await ref.read(hiveProvider(_boxName).future);

    try {
      if (!isCacheValid) {
        final apiData = await _readApi();
        await favoritesBox.put(_keyHomeWork, apiData.toHive());
        _lastUpdate = DateTime.now();
        return apiData;
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    final homeWork = favoritesBox.get(_keyHomeWork,
        defaultValue: FavoriteCacheState()) as FavoriteCacheState?;

    final FavoriteCacheItem? homeItem = homeWork?.home;
    final FavoriteCacheItem? workItem = homeWork?.work;
    final List<FavoriteCacheItem> placesList = homeWork?.places ?? [];

    return FavouritesState(
        home: homeItem?.toDomain(),
        work: workItem?.toDomain(),
        items: placesList.map((e) => e.toDomain()).toList());
  }

  Future<FavouritesState> _readApi() async {
    final apiData = await ref.read(favouriteRepositoryProvider.future);

    return apiData;
  }
}
