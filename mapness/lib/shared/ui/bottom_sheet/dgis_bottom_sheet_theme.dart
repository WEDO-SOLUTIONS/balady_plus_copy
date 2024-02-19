import 'dart:ui';

import 'package:balady_uikit/colors/non_theme_colors.dart';

/// contains theme for [DgisBottomSheet] widget
class DgisBottomSheetTheme {
  final Color handleColor;

  final Color expandedBackgroundColor;
  final Color bodyBackgroundColor;

  const DgisBottomSheetTheme({
    required this.bodyBackgroundColor,
    required this.expandedBackgroundColor,
    required this.handleColor,
  });

  // todo(someone): remove when theme will be provided in widget tree
  static const DgisBottomSheetTheme defaultTheme = DgisBottomSheetTheme(
    expandedBackgroundColor: NonThemeColor.color64,
    handleColor: NonThemeColor.color65,
    bodyBackgroundColor: NonThemeColor.color64,
  );
}
