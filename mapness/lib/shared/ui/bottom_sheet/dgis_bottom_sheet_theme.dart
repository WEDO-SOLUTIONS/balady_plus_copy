import 'dart:ui';

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
    expandedBackgroundColor: Color(0xFFFFFFFF),
    handleColor: Color(0xFFE0E0E0),
    bodyBackgroundColor: Color(0xFFF4F4F5),
  );
}
