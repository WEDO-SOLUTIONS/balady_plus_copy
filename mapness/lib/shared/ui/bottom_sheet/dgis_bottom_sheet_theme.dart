import 'dart:ui';

import 'package:balady_uikit/core/colors/non_theme_colors.dart';

/// contains theme for [DgisBottomSheet] widget
class DgisBottomSheetTheme {
  const DgisBottomSheetTheme({
    required this.bodyBackgroundColor,
    required this.expandedBackgroundColor,
    required this.handleColor,
  });
  final Color handleColor;

  final Color expandedBackgroundColor;
  final Color bodyBackgroundColor;

  // todo(someone): remove when theme will be provided in widget tree
  static const DgisBottomSheetTheme defaultTheme = DgisBottomSheetTheme(
    expandedBackgroundColor: NonThemeColor.color64,
    handleColor: NonThemeColor.color65,
    bodyBackgroundColor: NonThemeColor.color64,
  );
}
