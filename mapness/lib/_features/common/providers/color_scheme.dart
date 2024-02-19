import 'dart:ui';

import 'package:balady_uikit/colors/app_color_scheme.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'color_scheme.g.dart';

@Riverpod(keepAlive: true)
class ColorScheme extends _$ColorScheme {
  @override
  AppColorScheme build() {
    // final language = ref.watch(s);
    // final direction = switch (language) {
    //   Language.arabic => TextDirection.rtl,
    //   Language.english => TextDirection.ltr,
    // };

    return AppColorScheme.main;
  }

  Future<bool> needToShowBanner() async {
    final hive = await ref.read(hiveProvider("foundation_day").future);
    Future.delayed(
      const Duration(seconds: 3),
      () {
        return hive.put('foundation_day_dialog', false);
      },
    );
    // return hive.get('foundation_day_dialog', defaultValue: true);
    return true;
  }
}
