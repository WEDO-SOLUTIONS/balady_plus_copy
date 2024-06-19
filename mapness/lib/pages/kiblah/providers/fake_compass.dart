import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fake_compass.g.dart';

@riverpod
class FakeCompass extends _$FakeCompass {
  @override
  double build() {
    final gradusesList = [30.0, 10.0, 180.0, 210.0, 60.0, 360.0];
    int currentIndex = 0;
    double currentRotation = 0;

    const timerInterval = Duration(milliseconds: 75);

    const double smoothFactor = 0.1;

    void updateCompassRotation() {
      final targetRotation = gradusesList[currentIndex];
      final difference = targetRotation - currentRotation;

      currentRotation += difference * smoothFactor;

      if (difference.abs() < 0.1) {
        currentRotation = targetRotation;
        currentIndex = (currentIndex + 1) % gradusesList.length;
      }

      state = currentRotation;
    }

    final compassSubscription = Timer.periodic(
      timerInterval,
      (_) {
        updateCompassRotation();
      },
    );

    ref.onDispose(compassSubscription.cancel);

    return 0;
  }
}
