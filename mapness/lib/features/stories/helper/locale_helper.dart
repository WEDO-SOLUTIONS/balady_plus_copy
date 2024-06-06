import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

class StoryLocalization extends InheritedWidget {
  final AppLocalizations l10n;

  const StoryLocalization({
    required this.l10n,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  static StoryLocalization? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StoryLocalization>();

  @override
  bool updateShouldNotify(StoryLocalization oldWidget) =>
      l10n != oldWidget.l10n;
}
