import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
extension BuildContextExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
