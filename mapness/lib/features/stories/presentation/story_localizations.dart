import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

class StoryLocalizations extends InheritedWidget {
  const StoryLocalizations({
    required this.locale,
    required super.child,
    super.key,
  });
  final AppLocalizations locale;

  static StoryLocalizations? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StoryLocalizations>();

  @override
  bool updateShouldNotify(StoryLocalizations oldWidget) =>
      locale != oldWidget.locale;
}
