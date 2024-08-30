import 'package:flutter/animation.dart';

class FreeRoamStartState {
  final bool isAutorun;
  final bool canStart;
  final AnimationController? controller;

  const FreeRoamStartState({
    required this.isAutorun,
    required this.canStart,
    this.controller,
  });
  FreeRoamStartState copyWith({
    bool? isAutorun,
    bool? canStart,
    AnimationController? controller,
  }) =>
      FreeRoamStartState(
        isAutorun: isAutorun ?? this.isAutorun,
        canStart: canStart ?? this.canStart,
        controller: controller ?? this.controller,
      );
}
