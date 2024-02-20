import 'package:balady_uikit/colors/app_color_scheme.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'color_scheme.g.dart';

@Riverpod(keepAlive: true)
class ColorScheme extends _$ColorScheme {
  @override
  AppColorScheme build() => AppColorScheme.brown;

  Future<bool> needToShowBanner() async {
    final hive = await ref.read(hiveProvider('foundation_day').future);
    return hive.get('foundation_day_dialog', defaultValue: true);
  }

  Future<void> hideBanner() async {
    final hive = await ref.read(hiveProvider('foundation_day').future);
    await hive.put('foundation_day_dialog', false);
  }
}
