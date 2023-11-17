import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_language.g.dart';

enum Language {
  english,
  arabic,
}

extension LanguageData on Language {
  String get title => switch (this) {
        Language.english => "English",
        Language.arabic => "عربي",
      };

  String get icon => switch (this) {
        Language.english => "assets/icons/svg/ic_lang_en.svg",
        Language.arabic => "assets/icons/svg/ic_lang_ar.svg",
      };
}

@riverpod
class AppLanguage extends _$AppLanguage {
  @override
  Language build() => Language.arabic;

  void update(Language value) => state = value;
}
