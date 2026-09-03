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

  // Every successful search-result tap calls put() and then immediately
  // closes the search sheet, disposing this autoDispose notifier while the
  // SDK round trip is still in flight - the state write then landed on a
  // dead notifier as an unhandled zone error (33k telemetry events/week).
  bool _disposed = false;

  @override
  List<SearchHistoryDirectoryObjectMessage> build(String scope) {
    ref.onDispose(() => _disposed = true);
    _load();

    return [];
  }

  Future<void> _initDataSource() async {
    if (_dataSource != null) {
      return;
    }

    if (_useSdkDataSource) {
      if (_disposed) {
        return;
      }
      final controller = ref.read(dgisControllerProvider).value;
      if (controller != null) {
        _dataSource = DgisSdkSearchHistoryDataSource(controller);
      }
    } else {
      if (_disposed) {
        return;
      }
      final searchHistoryBox = await ref.read(hiveProvider('${_hiveBox}_$scope').future);
      if (_disposed) {
        return;
      }
      _dataSource = HiveSearchHistoryDataSource(searchHistoryBox);
    }
  }

  Future<void> _load() async {
    await _initDataSource();
    if (_disposed) {
      return;
    }
    final items = await _dataSource?.getSearchHistoryItems() ?? [];
    if (_disposed) {
      return;
    }
    state = items;
  }

  // In put/delete the guard goes AFTER the persistence await: the user's
  // intent (record/remove the history item) must still complete; only the
  // state write on a dead notifier is abandoned.
  Future<void> put(SearchHistoryDirectoryObjectMessage item) async {
    await _dataSource?.addSearchHistoryItem(item);
    if (_disposed) {
      return;
    }
    await _load();
  }

  Future<void> delete(int index) async {
    await _dataSource?.removeSearchHistoryItem(index);
    if (_disposed) {
      return;
    }
    await _load();
  }

  Future<void> clear() async {
    await _dataSource?.clear();
    if (_disposed) {
      return;
    }
    state = [];
  }
}
