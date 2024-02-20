import 'package:balady_uikit/colors/app_color_scheme.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'color_scheme.g.dart';

@Riverpod(keepAlive: true)
class ColorScheme extends _$ColorScheme {
  @override
  AppColorScheme build() {
    final now = DateTime.now();

    /// Feb 20 12 AM
    final startDate = DateTime(2024, 2, 20);

    /// Feb 25 11:59 PM
    final endDate = DateTime(2024, 2, 25, 23, 59, 59);

    assert(
      startDate.isBefore(endDate),
      'sanity check, start date should be before end date',
    );

    if (now.isAfter(startDate) && now.isBefore(endDate)) {
      return AppColorScheme.brown;
    }
    return AppColorScheme.main;
  }

  Future<bool> needToShowBanner() async {
    final hive = await ref.read(hiveProvider('foundation_day').future);
    return hive.get('foundation_day_dialog', defaultValue: true);
  }

  Future<void> hideBanner() async {
    final hive = await ref.read(hiveProvider('foundation_day').future);
    await hive.put('foundation_day_dialog', false);
  }
}
