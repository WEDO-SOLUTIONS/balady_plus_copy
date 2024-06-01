import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_history.g.dart';

/// change number to discard old data on all devices
/// Storage cost is low since items are small
const _hiveBox = 'searchHistory2';

@riverpod
class SearchHistory extends _$SearchHistory {
  @override
  List<SearchHistoryItem> build(String scope) {
    _load();

    return [];
  }

  Future<void> _load() async {
    final searchHistoryBox = await ref.read(hiveProvider('${_hiveBox}_$scope').future);

    final history = searchHistoryBox.values.map((e) => e as SearchHistoryItem).toList().reversed.toList();
    final ids = history.where((e) => e.objectId != null).map((e) => e.objectId!).toSet();
    history.retainWhere((e) => e.objectId == null || ids.remove(e.objectId));
    state = history;
  }

  Future<void> put(SearchHistoryItem item) async {
    final searchHistoryBox = await ref.read(hiveProvider('${_hiveBox}_$scope').future);

    await searchHistoryBox.put(item.hashKey, item);

    await _load();
  }

  Future<void> delete(SearchHistoryItem item) async {
    final searchHistoryBox = await ref.read(hiveProvider('${_hiveBox}_$scope').future);

    await searchHistoryBox.delete(item.hashKey);

    await _load();
  }

  Future<void> clear() async {
    final searchHistoryBox = await ref.read(hiveProvider('${_hiveBox}_$scope').future);

    await searchHistoryBox.clear();
    state = [];
  }
}
