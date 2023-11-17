import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'eager_init.g.dart';

@riverpod
class EagerInit extends _$EagerInit {
  @override
  Future<void> build() async {
    await ref.watch($asyncPrefsLoaderProvider.future);
    return;
  }
}
