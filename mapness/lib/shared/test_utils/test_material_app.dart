import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/app_language.dart';

class TestMaterialApp extends ConsumerWidget {
  final Language language;
  final Widget child;

  const TestMaterialApp({
    required this.child,
    super.key,
    this.language = Language.arabic,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
        theme: ThemeData(
          primarySwatch: const MaterialColor(
            0xFF4CA5B4,
            <int, Color>{
              50: Color(0xFF89cfbe),
              100: Color(0xFF89cfbe),
              200: Color(0xFF89cfbe),
              300: Color(0xFF89cfbe),
              400: Color(0xFF89cfbe),
              500: Color(0xFF89cfbe),
              600: Color(0xFF89cfbe),
              700: Color(0xFF89cfbe),
              800: Color(0xFF89cfbe),
              900: Color(0xFF89cfbe),
            },
          ),
          scaffoldBackgroundColor: Colors.transparent,
          dividerColor: Colors.grey[400],
          useMaterial3: false,
          extensions: <ThemeExtension<dynamic>>[
            if (language == Language.arabic) ThemeTextStyles.arabic() else ThemeTextStyles.english(),
            if (language == Language.arabic) ThemeTextStylesV3.frutiger() else ThemeTextStylesV3.golos(),
            AppColorsThemeExt.palette(isDark: false),
            AppColorsThemeV2.palette(isDark: false),
            AppColorsThemeV3.palette(themes: BaladyAppThemes.light),
          ],
        ),
        home: child,
        locale: language.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
      );
}
