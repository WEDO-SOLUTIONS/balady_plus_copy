part of '../content_row.dart';

/// Options for the trailing widget in the ContentRow.
sealed class ContentRowTrailingOptions {
  const ContentRowTrailingOptions();
}

/// Options for the trailing widget in the ContentRow.
class ContentRowTextTrailingOptions extends ContentRowTrailingOptions {
  final String? text;
  final TextStyle? textStyle;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onPressed;

  const ContentRowTextTrailingOptions({
    this.text,
    this.icon,
    this.iconColor,
    this.onPressed,
    this.textStyle,
  }) : assert(text != null || icon != null, 'At least one of the following should be provided: text, icon');
}

/// Options for the toggle trailing widget in the ContentRow.
/// Default value is false.
class ContentRowToggleTrailingOptions extends ContentRowTrailingOptions {
  final bool value;
  final ValueChanged<bool> onChanged;

  const ContentRowToggleTrailingOptions({
    required this.onChanged,
    this.value = false,
  });
}

/// Options for the trailing widget in the ContentRow.
class ContentRowCustomTrailingOptions extends ContentRowTrailingOptions {
  final Widget Function(BuildContext) builder;

  const ContentRowCustomTrailingOptions({
    required this.builder,
  });
}
