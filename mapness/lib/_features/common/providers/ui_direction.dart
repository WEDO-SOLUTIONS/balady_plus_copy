import 'dart:ui';

import 'package:mapness/shared/providers/app_language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_direction.g.dart';

@Riverpod(keepAlive: true)
class UiDirection extends _$UiDirection {
  @override
  TextDirection build() {
    final language = ref.watch(appLanguageProvider);
    final direction = switch (language) {
      Language.arabic => TextDirection.rtl,
      Language.english => TextDirection.ltr,
    };

    return direction;
  }
}
