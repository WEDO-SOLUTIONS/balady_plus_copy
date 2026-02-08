import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/themes/dark_theme.dart';
import 'package:balady_uikit/core/themes/light_theme.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:balady_uikit/core/typography/text_theme_styles_v3.dart';
import 'package:balady_uikit/core/utils/inspector_plus/src/inspector_plus.dart';
import 'package:example/widgetbook_app/widgetbook_app.directories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themes = [
      WidgetbookTheme(
        name: 'Dark',
        data: createAppDarkTheme(),
      ),
      WidgetbookTheme(
        name: 'Light',
        data: createAppLightTheme(),
      ),
    ];
    return Widgetbook.material(
      directories: directories,
      initialRoute: '24. Confetti animation',
      addons: [
        LocalizationAddon(
          locales: [
            const Locale('en', 'US'),
            const Locale('ar', 'AR'),
          ],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
        ),
        ThemeAddon(
          themes: themes,
          initialTheme: themes.last,
          themeBuilder: (context, theme, child) {
            // Wrap use cases with the custom theme's InheritedWidget
            final isArabic = context.locale.languageCode == 'ar';
            return Theme(
              data: theme.copyWith(
                extensions: [
                  ...theme.extensions.values,
                  if (isArabic) ThemeTextStylesV3.frutiger() else ThemeTextStylesV3.golos(),
                  if (isArabic) ThemeTextStyles.arabic() else ThemeTextStyles.english(),
                ],
              ),
              child: ColoredBox(
                color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black26,
                child: child,
              ),
            );
          },
        ),
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhoneSE,
            Devices.ios.iPhone13ProMax,
          ],
        ),
        InspectorAddon(enabled: true),
      ],
      appBuilder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black26,
          body: Center(child: child),
        );
      },
    );
  }
}

class InspectorAddonPlus extends WidgetbookAddon<bool> {
  final bool enabled;

  InspectorAddonPlus({
    this.enabled = false,
  }) : super(
          name: 'Inspector',
        );

  @override
  List<Field> get fields => [
        BooleanField(
          name: 'isEnabled',
          initialValue: enabled,
        ),
      ];

  @override
  bool valueFromQueryGroup(Map<String, String> group) {
    return valueOf('isEnabled', group) ?? false;
  }

  @override
  Widget buildUseCase(
    BuildContext context,
    Widget child,
    bool setting,
  ) {
    return WidgetBookInspector(
      isEnabled: true,
      zoomShortcuts: const [LogicalKeyboardKey.keyZ, LogicalKeyboardKey.keyZ],
      child: child,
    );
  }
}
