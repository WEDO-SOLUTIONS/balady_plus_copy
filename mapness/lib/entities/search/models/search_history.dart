import 'package:dgis_map/library.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapness/shared/lib/make_address.dart';

part 'search_history.g.dart';

@HiveType(typeId: 1)
class SearchHistoryItem {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String address;

  @HiveField(2)
  final int? objectId;

  @HiveField(3)
  final int? entranceId;

  SearchHistoryItem({
    required this.title,
    required this.address,
    required this.objectId,
    required this.entranceId,
  });

  factory SearchHistoryItem.fromDirectoryObject(
    DirectoryObjectMessage object,
  ) =>
      SearchHistoryItem(
        title: object.title,
        address: object.makeAddress(),
        objectId: object.id?.objectId,
        entranceId: object.id?.entranceId,
      );

  String get key => 'history-${objectId ?? 0}-${entranceId ?? 0}';
}
