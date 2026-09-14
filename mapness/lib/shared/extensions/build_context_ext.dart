import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_plus/app/features/accecipilities/balady_theme_controller.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
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

  /// Card surface used across profile/settings screens (matches Settings page).
  Color get profileCardColor {
    final themeController = read<ThemeController>();
    final palette = themeController.colors;
    final theme = themeController.currentTheme;
    final isDGA = theme == BaladyAppThemes.darkDGA || theme == BaladyAppThemes.lightDGA;
    return isDGA ? palette.accentSecondarySoft : palette.backgroundSurface1;
  }

  /// Field fill inside [profileCardColor] cards (gray on light cards, dark on dark cards).
  Color get profileFieldFillColor {
    final palette = read<ThemeController>().colors;
    return profileCardColor.computeLuminance() > 0.5 ? palette.backgroundSurface4 : palette.backgroundSurface1;
  }
}
