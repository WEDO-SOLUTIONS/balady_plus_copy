import 'package:dgis_map/library.dart';
import 'package:mapness/features/search/data/search_history_data_source.dart';

class DgisSdkSearchHistoryDataSource extends SearchHistoryDataSource {
  final DgisMapController controller;

  const DgisSdkSearchHistoryDataSource(this.controller);

  @override
  Future<List<SearchHistoryDirectoryObjectMessage>> getSearchHistoryItems() => controller.getSearchHistoryItems();

  @override
  Future<void> addSearchHistoryItem(SearchHistoryDirectoryObjectMessage item) =>
      controller.addSearchHistoryItem(item);

  @override
  Future<void> removeSearchHistoryItem(int index) =>
      controller.removeSearchHistoryItem(index);

  @override
  Future<void> clear() => controller.clearSearchHistoryItems();
}
