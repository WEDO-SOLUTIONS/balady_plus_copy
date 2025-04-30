import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urbi_analytics/logger.dart';

part 'navigator_voice.g.dart';

const String _prefsKey = 'navigator.voice';

@Riverpod(keepAlive: true)
class NavigatorVoice extends _$NavigatorVoice {
  @override
  String build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final voice = sharedPrefs.getString(_prefsKey) ?? ref.read(appLanguageProvider).navigatorVoice;

    update(voice);

    return voice;
  }

  void update(String value) {
    try {
      ref.read(dgisControllerProvider).value?.setNavigatorVoice(value);
      ref.read(sharedPrefsProvider).setString(_prefsKey, value);
      state = value;
    } catch (e) {
      log('Set voice error: ${e.toString()}');
    }
  }
}
