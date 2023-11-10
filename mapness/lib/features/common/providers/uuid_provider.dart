import 'dart:async';

import 'package:mapness/features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'uuid_provider.g.dart';

@riverpod
class UuidProvider extends _$UuidProvider {
  @override
  String build() {
    final prefs = ref.watch(sharedPrefsProvider);
    if (prefs.containsKey('uuid')) {
      return prefs.getString('uuid')!;
    }
    final uuid = const Uuid().v4();
    unawaited(prefs.setString('uuid', uuid));
    return uuid;
  }
}
