import 'dart:ui';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/shared/providers/navigator_voice.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_language.g.dart';

const _prefsKey = "settings.language";

enum Language {
  english,
  arabic;

  static Language fromString(String? s) {
    return switch (s) {
      "english" => Language.english,
      "arabic" => Language.arabic,
      _ => Language.arabic
    };
  }
}

///TODO need to get from context.l10n
extension LanguageData on Language {
  String get title => switch (this) {
        Language.english => "English",
        Language.arabic => "عربي",
      };

  String get icon => switch (this) {
        Language.english => "assets/icons/svg/ic_lang_en.svg",
        Language.arabic => "assets/icons/svg/ic_lang_ar.svg",
      };

  Locale get locale => switch (this) {
        Language.english => const Locale('en'),
        Language.arabic => const Locale('ar'),
      };

  String get navigatorVoice => switch (this) {
        Language.english => "voice-jennifer",
        Language.arabic => "voice-sara",
      };

  String get baladyCompat => switch (this) {
        Language.english => "en",
        Language.arabic => "ar",
      };
}

@Riverpod(keepAlive: true)
class AppLanguage extends _$AppLanguage {
  @override
  Language build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);

    final language = Language.fromString(sharedPrefs.getString(_prefsKey));
    CommonFunctions.changeLanguage(lang: language.baladyCompat);

    return language;
  }

  void update(Language value) {
    ref.read(sharedPrefsProvider).setString(_prefsKey, value.name);
    ref.read(navigatorVoiceProvider.notifier).update(value.navigatorVoice);
    CommonFunctions.changeLanguage(lang: value.baladyCompat);
    state = value;
  }
}
