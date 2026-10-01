import 'package:balady_uikit/balady_uikit.dart';

class SheetActionButton {
  const SheetActionButton({
    required this.label,
    required this.onTap,
    this.buttonColorScheme = ButtonColorScheme.accentSecondary,
    this.buttonType = ButtonType.secondary,
    this.showsLoadingAndHandlesErrors = false,
  });

  final String label;
  final ButtonColorScheme buttonColorScheme;
  final ButtonType buttonType;
  final bool showsLoadingAndHandlesErrors;
  final Future<void> Function() onTap;
}
