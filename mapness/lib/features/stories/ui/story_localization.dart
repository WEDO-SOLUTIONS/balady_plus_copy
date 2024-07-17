import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

class StoryLocalization extends InheritedWidget {
  const StoryLocalization({
    required this.locale,
    required super.child,
    super.key,
  });
  final AppLocalizations locale;

  static StoryLocalization of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<StoryLocalization>()!;

  @override
  bool updateShouldNotify(StoryLocalization oldWidget) => locale != oldWidget.locale;
}
