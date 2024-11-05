import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stories_open_state.g.dart';

@riverpod
class StoriesOpenState extends _$StoriesOpenState {
  @override
  bool build() => false;

  void open() {
    state = true;
  }

  void close() {
    state = false;
  }
}
