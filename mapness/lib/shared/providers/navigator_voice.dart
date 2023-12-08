import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigator_voice.g.dart';

const String _prefsKey = "navigator.voice";

@riverpod
class NavigatorVoice extends _$NavigatorVoice {
  @override
  String build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);

    return sharedPrefs.getString(_prefsKey) ?? "voice-sara";
  }

  void update(String value) {
    ref.read(dgisControllerProvider).value?.setNavigatorVoice(value);
    ref.read(sharedPrefsProvider).setString(_prefsKey, value);
    state = value;
  }
}
