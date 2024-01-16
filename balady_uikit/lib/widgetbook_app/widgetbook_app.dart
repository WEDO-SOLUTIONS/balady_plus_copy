import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'widgetbook_app.directories.g.dart';

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      appBuilder: (ctx, child) {
        return Scaffold(
          body: child,
        );
      },
      // Use the generated directories variable
      directories: directories,
      addons: [
        TextScaleAddon(
          scales: [1.0, 2.0],
        ),
        LocalizationAddon(
          locales: [
            const Locale('en', 'US'),
            const Locale('ar', 'AR'),
          ],
          localizationsDelegates: [
            DefaultWidgetsLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
          ],
        ),
        ThemeAddon(
            themes: [
              WidgetbookTheme(
                name: 'Light',
                data: ThemeData.light(),
              ),
              WidgetbookTheme(
                name: 'Dark',
                data: ThemeData.dark(),
              ),
            ],
            themeBuilder: (context, theme, child) {
              // Wrap use cases with the custom theme's InheritedWidget
              return Theme(
                data: ThemeData(
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
                  unselectedWidgetColor: const Color(0xFF1E2A36),
                  scaffoldBackgroundColor: Colors.transparent,
                  dividerColor: Colors.grey[400],
                  useMaterial3: false,
                  extensions: <ThemeExtension<dynamic>>[
                    ThemeTextStyles.arabic(isDark: false),
                  ],
                ),
                child: child,
              );
            }),
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhoneSE,
            Devices.ios.iPhone13,
          ],
        ),
      ],
    );
  }
}
