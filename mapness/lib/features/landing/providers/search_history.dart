import 'package:dgis_map/library.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mapness/features/common/providers/hive.dart';
import 'package:mapness/legacy_features/routing_page/data/directory_object_ext.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_history.g.dart';

@HiveType(typeId: 1)
class HistoryItem {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String address;

  @HiveField(2)
  final int? objectId;

  @HiveField(3)
  final int? entranceId;

  HistoryItem({
    required this.title,
    required this.address,
    required this.objectId,
    required this.entranceId,
  });

  static HistoryItem fromDirectoryObject(DirectoryObjectMessage object) {
    return HistoryItem(
      title: object.title,
      address: object.makeAddress(),
      objectId: object.id?.objectId,
      entranceId: object.id?.entranceId,
    );
  }
}

@riverpod
class SearchHistory extends _$SearchHistory {
  @override
  List<HistoryItem> build() {
    _load();

    return [];
  }

  Future<void> _load() async {
    final searchHistoryBox =
        await ref.watch(hiveProvider('searchHistory').future);

    state = searchHistoryBox.values.map((e) => e as HistoryItem).toList();
  }

  Future<void> put(HistoryItem result) async {
    final searchHistoryBox =
        await ref.read(hiveProvider('searchHistory').future);

    searchHistoryBox.add(result);
  }
}
