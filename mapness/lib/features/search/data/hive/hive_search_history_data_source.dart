import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:hive_ce/hive.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/data/search_history_data_source.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/search_type_ext.dart';

class HiveSearchHistoryDataSource extends SearchHistoryDataSource {
  final Box<dynamic> box;

  const HiveSearchHistoryDataSource(this.box);

  @override
  Future<List<SearchHistoryDirectoryObjectMessage>> getSearchHistoryItems() async {
    final items = box.values.map((e) => e as SearchHistoryItem).where((e) => e.objectId != null);
    return _sort(items).map((e) => e.toMessage()).toList();
  }

  Iterable<SearchHistoryItem> _sort(Iterable<SearchHistoryItem> items) => items.sorted((a, b) {
    final aCreated = a.createdAt;
    final bCreated = b.createdAt;
    if (aCreated != null && bCreated != null) {
      return DateTime.parse(bCreated).compareTo(DateTime.parse(aCreated));
    } else if (aCreated == null && bCreated == null) {
      return 0;
    } else if (aCreated != null && bCreated == null) {
      return -1;
    } else if (aCreated == null && bCreated != null) {
      return 1;
    }
    return 0;
  });

  @override
  Future<void> addSearchHistoryItem(SearchHistoryDirectoryObjectMessage item) async {
    final boxItem = SearchHistoryItem.fromMessage(item, DateTime.timestamp());
    await box.put(item.hashKey, boxItem);
  }

  @override
  Future<void> removeSearchHistoryItem(int index) async {
    final item = (await getSearchHistoryItems()).elementAtOrNull(index);
    if (item != null) {
      await box.delete(item.hashKey);
    }
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }
}
