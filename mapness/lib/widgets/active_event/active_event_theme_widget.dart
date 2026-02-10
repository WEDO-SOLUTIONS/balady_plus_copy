import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/shared/extensions/theme_extensions.dart';
import 'package:mapness/widgets/founding_day/founding_day_theme.dart';

class ActiveEventThemeWrapper extends ConsumerWidget {
  final Widget child;
  const ActiveEventThemeWrapper({required this.child, super.key}) : _isSecondary = false;
  final bool _isSecondary;

  const ActiveEventThemeWrapper.secondary({required this.child, super.key}) : _isSecondary = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeEvent = ref.watch(activeCityEventProvider);
    final baseTheme = Theme.of(context);

    return switch (activeEvent) {
      CityEventType.foundingDay => Theme(
        data: baseTheme.overrideExtension(AppColorsThemeV3FoundingDayExt.foundingDay(isSecondary: _isSecondary)),
        child: child,
      ),
      _ => child,
    };
  }
}
