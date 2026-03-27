import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';
import 'package:mapness/widgets/search/ui/working_hours_colors.dart';

void main() {
  final colors = AppColorsThemeV3.palette(themes: BaladyAppThemes.dark);
  final workingHours = WorkingHours({Duration(days: DateTime.monday, hours: 10): const Duration(hours: 8)});

  test('THEN openSoon uses extra01 colors', () {
    final result = workingHours.colors(DateTime(2025, 9, 1, 16, 30), colors);

    expect(result?.text, colors.extra01Default);
    expect(result?.background, colors.extra01ContainerDefault.withValues(alpha: 0.1));
  });

  test('THEN closedSoon uses error colors', () {
    final result = workingHours.colors(DateTime(2025, 9, 1, 9, 30), colors);

    expect(result?.text, colors.errorOnContainer);
    expect(result?.background, colors.errorContainerDefault);
  });
}
