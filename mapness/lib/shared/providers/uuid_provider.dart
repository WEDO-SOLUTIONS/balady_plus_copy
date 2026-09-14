import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'uuid_provider.g.dart';

@riverpod
class UuidProvider extends _$UuidProvider {
  @override
  String build() {
    final prefs = ref.watch(sharedPrefsProvider);
    if (!prefs.containsKey('uuid')) {
      randomize();
    }
    return prefs.getString('uuid')!;
  }

  void randomize() {
    final uuid = const Uuid().v4();

    ref.read(sharedPrefsProvider).setString('uuid', uuid);
    ref.invalidateSelf();
  }
}
