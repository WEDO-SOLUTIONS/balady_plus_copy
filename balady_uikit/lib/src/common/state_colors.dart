import 'dart:ui';

/// The colors of the widget
class WidgetColors {
  final Color background;
  final Color foreground;

  const WidgetColors({
    required this.background,
    required this.foreground,
  });
}

/// The set of colors of the widget based on the different parameters e.g. type, selected state, enabled state
class WidgetStateColors {
  final Color defaultValue;
  final Color pressed;
  final Color disabled;

  const WidgetStateColors({
    required this.defaultValue,
    required this.pressed,
    required this.disabled,
  });
}

/// The set of colors of the widget based on the different parameters e.g. type, selected state, enabled state
class WidgetButtonStateColors {
  final WidgetColors defaultValue;
  final WidgetColors pressed;
  final WidgetColors disabled;
  final WidgetColors loading;

  const WidgetButtonStateColors({
    required this.defaultValue,
    required this.pressed,
    required this.disabled,
    required this.loading,
  });
}
