import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dark_mode.g.dart';

@riverpod
class DarkMode extends _$DarkMode {
  @override
  bool build() => false;

  void toggle() => state = !state;
}
