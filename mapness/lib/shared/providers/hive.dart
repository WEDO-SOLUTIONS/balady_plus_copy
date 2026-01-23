import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hive.g.dart';

@Riverpod(keepAlive: true)
class _Hive extends _$Hive {
  @override
  Future<Box<dynamic>> build(String boxName) async {
    final box = await Hive.openBox(boxName);

    ref.onDispose(box.close);
    return box;
  }
}

final hiveProvider = _hiveProvider;
