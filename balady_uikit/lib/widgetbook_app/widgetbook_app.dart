import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'widgetbook_app.directories.g.dart';

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Widgetbook.material(
          integrations: [],
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
                  data: theme,
                  child: child,
                );
              },
            ),
            DeviceFrameAddon(
              devices: [
                Devices.ios.iPhoneSE,
                Devices.ios.iPhone13,
              ],
            ),
          ],
          appBuilder: (context, child) {
            final colorScheme = Theme.of(context).colorScheme;
            return Scaffold(
            appBar: AppBar(),
            backgroundColor: colorScheme.background,
            body: child,
          );
          },
        ),
      );
}
