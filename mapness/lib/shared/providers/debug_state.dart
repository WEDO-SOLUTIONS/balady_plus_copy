import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debug_state.g.dart';

@riverpod
class DebugState extends _$DebugState {
  @override
  bool build() => false;

  void enable() {
    state = true;
  }
}
