import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'eta_timer_indicator.g.dart';

@riverpod
class EtaTimerIndicator extends _$EtaTimerIndicator {
  Timer? _timer;

  @override
  int build() => 0;

  void startTimer(int durationInMinutes) {
    state = durationInMinutes;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (state == 0) {
        timer.cancel();
      } else {
        state = state - 1;
      }
    });
    ref.onDispose(() => _timer?.cancel());
  }

  void stopTimer() {
    state = 0;
    _timer?.cancel();
    _timer = null;
  }
}
