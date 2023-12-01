import 'dart:ui';

import 'package:mapness/_features/common/providers/shared_prefs.dart';
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
}

@riverpod
class AppLanguage extends _$AppLanguage {
  @override
  Language build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);

    return Language.fromString(sharedPrefs.getString(_prefsKey));
  }

  void update(Language value) {
    ref.read(sharedPrefsProvider).setString(_prefsKey, value.name);
    state = value;
  }
}
