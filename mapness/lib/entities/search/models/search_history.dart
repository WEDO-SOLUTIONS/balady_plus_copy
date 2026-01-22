import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dgis_map/library.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mapness/shared/lib/make_address.dart';

part 'search_history.g.dart';

@HiveType(typeId: 1)
class SearchHistoryItem {
  const SearchHistoryItem({
    required this.title,
    required this.address,
    required this.objectId,
    required this.entranceId,
    this.createdAt,
  });

  factory SearchHistoryItem.fromDirectoryObject(
    DirectoryObjectMessage object,
  ) =>
      SearchHistoryItem(
        title: object.title,
        address: object.makeAddress(),
        objectId: object.id?.objectId.toString(),
        entranceId: object.id?.entranceId.toString(),
        createdAt: DateTime.timestamp().toIso8601String(),
      );

  factory SearchHistoryItem.fromQuery({
    required String query,
  }) =>
      SearchHistoryItem(
        title: query,
        address: '',
        objectId: null,
        entranceId: null,
        createdAt: DateTime.timestamp().toIso8601String(),
      );
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String address;

  /// String because Hive have problems with int
  @HiveField(2)
  final String? objectId;

  @HiveField(3)
  final String? entranceId;

  /// Should be timestamp
  @HiveField(4)
  final String? createdAt;

  String get hashKey =>
      'history-${objectId ?? 0}-${entranceId ?? 0}-${sha1.convert(utf8.encode(title))}-${sha1.convert(utf8.encode(address))}';
}
