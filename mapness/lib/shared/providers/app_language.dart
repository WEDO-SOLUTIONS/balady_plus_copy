import 'dart:async';
import 'dart:io';

import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/features/weather/provider/forecast_weather_provider.dart';
import 'package:mapness/shared/providers/navigator_voice.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_language.g.dart';

const _prefsKey = 'settings.language';
const _cachedMiniAppsLangKey = 'cached.miniapps.language';

enum Language {
  english,
  arabic;

  static Language fromString(String? s) => switch (s) {
        'english' => Language.english,
        'arabic' => Language.arabic,
        // default is arabic
        _ => Platform.localeName.toLowerCase().contains('en') ? Language.english : Language.arabic,
      };

  static Language? parceString(String? s) => switch (s) {
        'en' => Language.english,
        'ar' => Language.arabic,
        _ => null,
      };
}

///TODO need to get from context.l10n
extension LanguageData on Language {
  String get title => switch (this) {
        Language.english => 'English',
        Language.arabic => 'عربي',
      };

  String get icon => switch (this) {
        Language.english => Assets.icons.svg.icLangEn.keyName,
        Language.arabic => Assets.icons.svg.icLangAr.keyName,
      };

  Locale get locale => switch (this) {
        Language.english => const Locale('en'),
        Language.arabic => const Locale('ar'),
      };

  String get navigatorVoice => switch (this) {
        Language.english => 'voice-daniel',
        Language.arabic => 'voice-saud',
      };

  String get baladyCompat => switch (this) {
        Language.english => 'en',
        Language.arabic => 'ar',
      };

  String get languageCode => this == Language.arabic ? 'ar_SA' : 'en_SA';

  bool get isEnglish => this == Language.english;

  bool get isArabic => this == Language.arabic;
}

@Riverpod(keepAlive: true)
class AppLanguage extends _$AppLanguage {
  @override
  Language build() {
    final sharedPrefs = ref.read(sharedPrefsProvider);

    final language = Language.fromString(sharedPrefs.getString(_prefsKey));
    // Because the 3d party code use context, we need wait for the context to be available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          NavigationService.navigatorKey.currentContext == null
              // wait for 5 seconds to get the context
              ? const Duration(seconds: 5)
              : Duration.zero,
          () => CommonFunctions.changeLanguage(lang: language.baladyCompat));
    });

    return language;
  }

  Future<void> update(Language value) async {
    // Main language change. We use information from this classes in other places
    // so we need to update the prefs and translator first
    await ref.read(sharedPrefsProvider).setString(_prefsKey, value.name);
    CommonFunctions.changeLanguage(lang: value.baladyCompat);

    ref.read(navigatorVoiceProvider.notifier).update(value.navigatorVoice);
    // Update the SSO profile to get the information in the new language
    unawaited(ref.read(authProvider.notifier).forceUpdate());
    // Update cached text for the favourites items
    unawaited(ref.read(favouriteCacheProvider.notifier).forceRefresh());

    state = value;

    // Invalidate weather provider after state update to avoid circular dependency
    Future.microtask(() => ref.invalidate(forecastWeatherProvider));
  }

  Future<void> updateCachedMiniAppsLanguage(String value) async {
    await ref.read(sharedPrefsProvider).setString(_cachedMiniAppsLangKey, value);
  }

  String? getCachedMiniAppsLanguage() => ref.read(sharedPrefsProvider).getString(_cachedMiniAppsLangKey);
}
