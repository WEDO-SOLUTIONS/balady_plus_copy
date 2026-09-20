import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/features/tifo/providers/tifo_districts_provider.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
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
    _ => fromSystemLocale(),
  };

  /// Device / OS locale — independent of in-app language preference.
  static Language fromSystemLocale() {
    final preferredLocales = PlatformDispatcher.instance.locales;
    if (preferredLocales.isNotEmpty) {
      final languageCode = preferredLocales.first.languageCode.toLowerCase();
      return languageCode.startsWith('en') ? Language.english : Language.arabic;
    }

    final locale = Platform.localeName.toLowerCase();
    return locale.startsWith('en') ? Language.english : Language.arabic;
  }

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
    // to fix performance issue on app start
    // // Because the 3d party code use context, we need wait for the context to be available
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Future.delayed(
    //     NavigationService.navigatorKey.currentContext == null
    //         // wait for 5 seconds to get the context
    //         ? const Duration(seconds: 5)
    //         : Duration.zero,
    //     () => CommonFunctions.changeLanguage(lang: language.baladyCompat),
    //   );
    // });

    return language;
  }

  Future<void> update(Language value) async {
    // optional guard
    if (state == value) return;

    // ✅ 1) Update state FIRST (breaks many cycles immediately)
    state = value;

    // ✅ 2) Persist + external translator change
    await ref.read(sharedPrefsProvider).setString(_prefsKey, value.name);
    CommonFunctions.changeLanguage(lang: value.baladyCompat);

    // ✅ 3) Keep your updates (still inside update)
    ref.read(navigatorVoiceProvider.notifier).update(value.navigatorVoice);
    // Update the SSO profile to get the information in the new language
    unawaited(ref.read(authProvider.notifier).forceUpdate());
    // Update cached text for the favourites items
    unawaited(ref.read(favouriteCacheProvider.notifier).forceRefresh());
    // Re-fetch the TIFO roster so club names come back in the new locale
    unawaited(ref.read(tifoSessionProvider.notifier).forceRefresh());
    // District names ship with the geometry payload, which is otherwise
    // cached for the whole app run — refetch it too (BALADY-3959).
    unawaited(ref.read(tifoDistrictsProvider.notifier).forceRefresh());

    state = value;

    // Invalidate weather provider after the current frame to avoid circular
    // dependency (appLanguage → forecastWeather → weatherRepository → appLanguage).
    // Using the container directly so the invalidation is not tracked as a
    // dependency of AppLanguage.
    final container = ref.container;
    Future.microtask(() => container.invalidate(forecastWeatherProvider));
  }

  /*
    1) persist
    await ref.read(sharedPrefsProvider).setString(_prefsKey, value.name);

    2) update state first (important)
    state = value;

    3) external change (no providers)
    CommonFunctions.changeLanguage(lang: value.baladyCompat);

  */

  Future<void> updateCachedMiniAppsLanguage(String value) async {
    await ref.read(sharedPrefsProvider).setString(_cachedMiniAppsLangKey, value);
  }

  String? getCachedMiniAppsLanguage() => ref.read(sharedPrefsProvider).getString(_cachedMiniAppsLangKey);
}
