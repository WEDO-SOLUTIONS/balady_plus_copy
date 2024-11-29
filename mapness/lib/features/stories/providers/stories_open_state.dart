import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stories_open_state.g.dart';

@Riverpod(keepAlive: true)
class StoriesOpenState extends _$StoriesOpenState {
  @override
  bool build() => stateOrNull ?? false;

  void open() {
    state = true;
  }

  void close() {
    state = false;
  }
}
