import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'beta_notification.g.dart';

const String _prefsKey = 'beta_shown';

@riverpod
class BetaNotification extends _$BetaNotification {
  @override
  bool build() => ref.read(sharedPrefsProvider).getBool(_prefsKey) ?? false;

  void setShown() {
    state = true;
    ref.read(sharedPrefsProvider).setBool(_prefsKey, state);
  }
}
