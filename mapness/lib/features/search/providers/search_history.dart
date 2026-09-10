import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:hive_ce/hive.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/data/dgis_sdk/dgis_sdk_search_history_data_source.dart';
import 'package:mapness/features/search/data/hive/hive_search_history_data_source.dart';
import 'package:mapness/features/search/data/search_history_data_source.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_history.g.dart';

/// change number to discard old data on all devices
/// Storage cost is low since items are small
const _hiveBox = 'searchHistory2';

const _useSdkDataSource = true;

Future<SearchHistoryDataSource?> _resolveDataSource(Ref ref, String scope) async {
  if (_useSdkDataSource) {
    final controller = ref.read(dgisControllerProvider).value;
    return controller == null ? null : DgisSdkSearchHistoryDataSource(controller);
  }

  return HiveSearchHistoryDataSource(await ref.read(hiveProvider('${_hiveBox}_$scope').future));
}

const _bucketBox = 'searchHistoryBuckets';
const _activeIdentityKey = '__active_identity__';
const visitorSearchHistoryIdentity = 'visitor';
const _bucketLimit = 20;
const _controllerWait = Duration(seconds: 10);
Future<void> _swaps = Future<void>.value();
Future<void> reconcileSearchHistoryIdentity(Ref ref, {required String identity}) async {
  final emptied = Completer<void>();
  _swaps = _swaps.then((_) => _reconcile(ref, identity: identity, emptied: emptied)).catchError((Object error) {
    logger.log('Search history reconcile to $identity failed: $error', logLevel: MapnessLogLevel.critical);
    if (!emptied.isCompleted) {
      emptied.complete();
    }
  });
  await emptied.future;
  try {
    for (final scope in SearchScopeEnum.values) {
      ref.invalidate(searchHistoryProvider(scope.value));
    }
  } on Object catch (_) {
    // Ref disposed while the store was being emptied — nothing to refresh.
  }
}

Future<void> _reconcile(Ref ref, {required String identity, required Completer<void> emptied}) async {
  try {
    final Box<dynamic> box;
    try {
      box = await ref.read(hiveProvider(_bucketBox).future);
    } on Object catch (error) {
      logger.log('Cannot open search history buckets: $error', logLevel: MapnessLogLevel.critical);
      return;
    }

    final active = box.get(_activeIdentityKey);
    final owner = active is String ? active : null;

    if (owner == identity) {
      return;
    }

    if (owner == null) {
      await box.put(_activeIdentityKey, identity);
      return;
    }

    final dataSource = await _resolveDataSourceForSwap(ref);
    if (dataSource == null) {
      logger.log('Cannot swap search history $owner -> $identity', logLevel: MapnessLogLevel.critical);
      return;
    }

    await _swapIdentity(dataSource, box, from: owner, to: identity, emptied: emptied);
  } finally {
    if (!emptied.isCompleted) {
      emptied.complete();
    }
  }
}

Future<SearchHistoryDataSource?> _resolveDataSourceForSwap(Ref ref) async {
  if (!_useSdkDataSource) {
    return _resolveDataSource(ref, SearchScopeEnum.map.value);
  }

  try {
    return DgisSdkSearchHistoryDataSource(await ref.read(dgisControllerProvider.future).timeout(_controllerWait));
  } on Object catch (error) {
    logger.log('Search history swap could not reach the map: $error', logLevel: MapnessLogLevel.critical);
    return null;
  }
}

Future<void> _swapIdentity(
  SearchHistoryDataSource dataSource,
  Box<dynamic> box, {
  required String from,
  required String to,
  required Completer<void> emptied,
}) async {
  var isEmptied = false;
  try {
    try {
      await box.put(from, await _snapshot(dataSource));
    } on Object catch (error) {
      logger.log('Failed to archive $from search history: $error', logLevel: MapnessLogLevel.critical);
    }

    try {
      await dataSource.clear();
      isEmptied = true;
      await box.put(_activeIdentityKey, to);
    } on Object catch (error) {
      logger.log('Failed to empty search history for $from -> $to: $error', logLevel: MapnessLogLevel.critical);
    }
  } finally {
    if (!emptied.isCompleted) {
      emptied.complete();
    }
  }
  if (!isEmptied) {
    return;
  }

  await _playback(dataSource, _readBucket(box, to));
}

Future<List<SearchHistoryItem>> _snapshot(SearchHistoryDataSource dataSource) async {
  final items = (await dataSource.getSearchHistoryItems()).take(_bucketLimit).toList();
  final now = DateTime.timestamp();

  return [
    for (final (index, item) in items.indexed)
      SearchHistoryItem.fromMessage(item, now.subtract(Duration(seconds: index))),
  ];
}

List<SearchHistoryItem> _readBucket(Box<dynamic> box, String identity) {
  final stored = box.get(identity);

  return stored is List ? stored.whereType<SearchHistoryItem>().toList() : const [];
}

Future<void> _playback(SearchHistoryDataSource dataSource, List<SearchHistoryItem> items) async {
  for (final item in items.reversed) {
    try {
      await dataSource.addSearchHistoryItem(item.toMessage());
    } on Object catch (error) {
      logger.log('Failed to restore search history entry: $error', logLevel: MapnessLogLevel.warning);
    }
  }
}

@riverpod
class SearchHistory extends _$SearchHistory {
  SearchHistoryDataSource? _dataSource;

  @override
  List<SearchHistoryDirectoryObjectMessage> build(String scope) {
    _load();

    return [];
  }

  Future<void> _initDataSource() async {
    _dataSource ??= await _resolveDataSource(ref, scope);
  }

  Future<void> _load() async {
    await _initDataSource();
    final items = await _dataSource?.getSearchHistoryItems() ?? [];
    if (!ref.mounted) {
      return;
    }
    state = items;
  }

  Future<void> put(SearchHistoryDirectoryObjectMessage item) async {
    final dataSource = await _store();
    if (dataSource == null) {
      return;
    }

    await dataSource.addSearchHistoryItem(item);
    await _load();
  }

  Future<void> delete(int index) async {
    final dataSource = await _store();
    if (dataSource == null) {
      return;
    }

    await dataSource.removeSearchHistoryItem(index);
    await _load();
  }

  Future<SearchHistoryDataSource?> _store() async {
    await _initDataSource();
    final dataSource = _dataSource;
    if (dataSource == null) {
      logger.log('Dropped a search history write: no store available', logLevel: MapnessLogLevel.critical);
    }

    return dataSource;
  }

  Future<void> clear() async {
    await (await _store())?.clear();
    if (!ref.mounted) {
      return;
    }
    state = [];
  }
}
