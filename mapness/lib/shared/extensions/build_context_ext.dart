import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/ui/palette/balady_temp_palette.dart';

extension BuildContextExt on BuildContext {
  bool get isLTR => Directionality.of(this) == TextDirection.ltr;

  AppLocalizations get l10n => AppLocalizations.of(this);

  // Temp palette for new design colors => colorsV3tmp
  BaladyTempPalette get colorsV3tmp => Theme.of(this).extension<BaladyTempPalette>()!;
}
