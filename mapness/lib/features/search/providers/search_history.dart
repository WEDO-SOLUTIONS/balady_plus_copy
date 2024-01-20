import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_history.g.dart';

const _hiveBox = 'searchHistory';

@riverpod
class SearchHistory extends _$SearchHistory {
  @override
  List<SearchHistoryItem> build(String scope) {
    _load();

    return [];
  }

  Future<void> _load() async {
    final searchHistoryBox =
        await ref.read(hiveProvider('${_hiveBox}_$scope').future);

    final history = searchHistoryBox.values
        .map((e) => e as SearchHistoryItem)
        .toList()
        .reversed
        .toList();
    final ids = history.map((e) => e.objectId!).toSet();
    history.retainWhere((e) => ids.remove(e.objectId));
    state = history;
  }

  Future<void> put(SearchHistoryItem item) async {
    final searchHistoryBox =
        await ref.read(hiveProvider('${_hiveBox}_$scope').future);

    await searchHistoryBox.put(item.key, item);

    await _load();
  }

  Future<void> delete(SearchHistoryItem item) async {
    final searchHistoryBox =
        await ref.read(hiveProvider('${_hiveBox}_$scope').future);

    await searchHistoryBox.delete(item.key);

    await _load();
  }

  Future<void> clear() async {
    final searchHistoryBox =
        await ref.read(hiveProvider('${_hiveBox}_$scope').future);

    await searchHistoryBox.clear();
    state = [];
  }
}
