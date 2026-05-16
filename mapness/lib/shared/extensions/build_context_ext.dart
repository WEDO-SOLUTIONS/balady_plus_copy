import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

extension BuildContextExt on BuildContext {
  bool get isLTR => Directionality.of(this) == TextDirection.ltr;

  AppLocalizations get l10n => AppLocalizations.of(this);

  void changeSystemNavBar() {
    final isLandscape = MediaQuery.orientationOf(this) == Orientation.landscape;
    final themeController = read<ThemeController>();
    SystemChrome.setSystemUIOverlayStyle(
      isLandscape
          ? themeController.systemOverlayStyle.copyWith(
              systemNavigationBarColor: const Color(0x00000000),
              systemNavigationBarContrastEnforced: false,
            )
          : themeController.systemOverlayStyle,
    );
  }
}
