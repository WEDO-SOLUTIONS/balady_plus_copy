import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'eager_init.g.dart';

@riverpod
class EagerInit extends _$EagerInit {
  @override
  Future<void> build() async {
    await ref.watch($asyncPrefsLoaderProvider.future);
    // Pre-resolve dark mode so the map can read it synchronously on startup
    await ref.watch(darkModeProvider.future);
    return;
  }
}
