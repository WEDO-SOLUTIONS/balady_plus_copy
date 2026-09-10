import 'package:dgis_map/library.dart';
import 'package:mapness/features/search/data/dgis_sdk/dgis_sdk_search_history_data_source.dart';
import 'package:mapness/features/search/data/hive/hive_search_history_data_source.dart';
import 'package:mapness/features/search/data/search_history_data_source.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_history.g.dart';

/// change number to discard old data on all devices
/// Storage cost is low since items are small
const _hiveBox = 'searchHistory2';

const _useSdkDataSource = true;

@riverpod
class SearchHistory extends _$SearchHistory {
  SearchHistoryDataSource? _dataSource;

  @override
  List<SearchHistoryDirectoryObjectMessage> build(String scope) {
    _load();

    return [];
  }

  Future<void> _initDataSource() async {
    if (_dataSource != null) {
      return;
    }

    if (_useSdkDataSource) {
      final controller = ref.read(dgisControllerProvider).value;
      if (controller != null) {
        _dataSource = DgisSdkSearchHistoryDataSource(controller);
      }
    } else {
      final searchHistoryBox = await ref.read(hiveProvider('${_hiveBox}_$scope').future);
      _dataSource = HiveSearchHistoryDataSource(searchHistoryBox);
    }
  }

  Future<void> _load() async {
    await _initDataSource();
    // Tapping a search result calls put() and closes the sheet at once, so this
    // autoDispose notifier is gone while the SDK round trip is still in flight
    // and the write landed on a dead notifier (33k zone errors a week).
    final items = await _dataSource?.getSearchHistoryItems() ?? [];
    if (!ref.mounted) {
      return;
    }
    state = items;
  }

  Future<void> put(SearchHistoryDirectoryObjectMessage item) async {
    await _dataSource?.addSearchHistoryItem(item);
    await _load();
  }

  Future<void> delete(int index) async {
    await _dataSource?.removeSearchHistoryItem(index);
    await _load();
  }

  Future<void> clear() async {
    await _dataSource?.clear();
    if (!ref.mounted) {
      return;
    }
    state = [];
  }
}
