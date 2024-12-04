import 'package:balady_uikit/core/colors/app_color_scheme.dart';
import 'package:balady_uikit/core/colors/app_colors_theme.dart';
import 'package:balady_uikit/core/colors/app_static_colors_theme.dart';
import 'package:balady_uikit/core/colors/colors_v2/app_colors_theme_v2.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:balady_uikit/core/typography/text_theme_styles_v3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/color_scheme.dart' as provider;
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/palette/balady_temp_palette.dart';
import 'package:mocktail/mocktail.dart';

class MockColorSchemeProvider extends Notifier<AppColorScheme> with Mock implements provider.ColorScheme {
  @override
  AppColorScheme build() => AppColorScheme.main;
}

class TestMaterialApp extends ConsumerWidget {
  final Language language;
  final Widget child;

  const TestMaterialApp({super.key, this.language = Language.arabic, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(provider.colorSchemeProvider);

    return MaterialApp(
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
        // unselectedWidgetColor: context.color.textAndIconsBasePrimary,
        scaffoldBackgroundColor: Colors.transparent,
        dividerColor: Colors.grey[400],
        useMaterial3: false,
        extensions: <ThemeExtension<dynamic>>[
          if (language == Language.arabic) ThemeTextStyles.arabic() else ThemeTextStyles.english(),
          if (language == Language.arabic) ThemeTextStylesV3.frutiger() else ThemeTextStylesV3.golos(),
          AppColorsThemeExt.palette(colorScheme, isDark: false),
          AppColorsThemeV2.palette(isDark: false),
          AppStaticColorsThemeExt.palette(colorScheme),

          // Temp palette for new colors disign
          BaladyTempPalette.palette(),
        ],
      ),
      home: child,
      locale: language.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
    );
  }
}
