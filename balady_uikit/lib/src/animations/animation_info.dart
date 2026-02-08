import 'package:flutter/material.dart';

class AnimationInfo extends ChangeNotifier {
  AnimationStatus status;
  bool isAnimating;

  AnimationInfo({
    this.status = AnimationStatus.forward,
    this.isAnimating = false,
  });

  @override
  String toString() {
    return 'AnimationInfo{status: $status, isAnimating: $isAnimating}';
  }
}
