import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/themes/light_theme.dart';
import 'package:example/widgetbook_app/use_cases/slider/silder_demo.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const StatelessBottomSheetApp());

class StatelessBottomSheetApp extends StatelessWidget {
  const StatelessBottomSheetApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    final theme = createAppLightTheme();

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'AR'),
      ],
      theme: theme.copyWith(
        extensions: [
          ...theme.extensions.values,
          ThemeTextStyles.english(),
        ],
      ),
      home: const Scaffold(
        body: SliderDemo(),
      ),
    );
  }
}
