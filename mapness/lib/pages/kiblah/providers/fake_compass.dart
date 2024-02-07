import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fake_compass.g.dart';

@riverpod
class FakeCompass extends _$FakeCompass {
  @override
  double build() {
    final compassSubscription = Timer.periodic(
      const Duration(milliseconds: 50),
      (_) {
        state = (state + 1) % 361;
      },
    );

    ref.onDispose(() {
      compassSubscription.cancel();
    });

    return 0;
  }
}
