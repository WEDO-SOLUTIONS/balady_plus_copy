import 'package:dgis_map/library.dart';

abstract class SearchHistoryDataSource {
  const SearchHistoryDataSource();

  Future<List<SearchHistoryDirectoryObjectMessage>> getSearchHistoryItems();

  Future<void> addSearchHistoryItem(SearchHistoryDirectoryObjectMessage item);

  Future<void> removeSearchHistoryItem(int index);

  Future<void> clear();
}
