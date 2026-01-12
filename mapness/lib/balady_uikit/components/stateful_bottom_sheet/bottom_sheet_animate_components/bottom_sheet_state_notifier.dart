import 'package:flutter/material.dart';

class BottomSheetStateNotifier<StateType> extends InheritedWidget {
  final StateType _state;
  final double _stateInterpolation;

  const BottomSheetStateNotifier({
    required StateType state,
    required double stateInterpolation,
    required super.child,
    super.key,
  })  : _state = state,
        _stateInterpolation = stateInterpolation;

  StateType get state => _state;

  double get stateInterpolation => _stateInterpolation;

  @override
  bool updateShouldNotify(BottomSheetStateNotifier<StateType> oldWidget) =>
      oldWidget._state != state || oldWidget.stateInterpolation != stateInterpolation;

  static BottomSheetStateNotifier<StateType>? of<StateType>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BottomSheetStateNotifier<StateType>>();
  }
}
