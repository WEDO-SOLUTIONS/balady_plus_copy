import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/l10n/generated/app_localizations_ar.dart';
import 'package:mapness/l10n/generated/app_localizations_en.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'toast_localization.g.dart';

///Using for correct localization in toast overlay

@riverpod
class ToastLocale extends _$ToastLocale {
  @override
  AppLocalizations build() {
    final language = ref.watch(appLanguageProvider);

    return language == Language.english ? AppLocalizationsEn() : AppLocalizationsAr();
  }
}
