import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_feedback_canpop.g.dart';

@riverpod
class AppFeedbackCanPop extends _$AppFeedbackCanPop {
  @override
  bool build() => true;

  void disable() => state = false;

  void enable() => state = true;
}
