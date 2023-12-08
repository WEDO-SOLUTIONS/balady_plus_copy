import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

class StoryLocalizations extends InheritedWidget {
  final AppLocalizations locale;

  const StoryLocalizations({
    super.key,
    required this.locale,
    required Widget child,
  }) : super(child: child);

  static StoryLocalizations? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StoryLocalizations>();
  }

  @override
  bool updateShouldNotify(StoryLocalizations oldWidget) {
    return locale != oldWidget.locale;
  }
}
