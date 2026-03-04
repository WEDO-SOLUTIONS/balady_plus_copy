import 'package:flutter/material.dart';

/// Controls a [SymmetricExpandableList] scroll and animations.
///
/// Implements `animation` and `jump` to `item` inside [SymmetricExpandableList] on basic [ScrollController].
class SymmetricScrollController extends ScrollController {
  final Duration _animationDuration;
  double Function(int index)? _getSizeCallback;
  AnimationController? _animationController;

  int _itemsCount = 0;

  SymmetricScrollController({
    required TickerProvider vsync,
    Duration? animationDuration,
    int initialIndex = 0,
  })  : _index = initialIndex,
        _previousIndex = initialIndex,
        _animationDuration = animationDuration ?? kTabScrollDuration,
        _animationController = AnimationController.unbounded(
          value: initialIndex.toDouble(),
          vsync: vsync,
        );

  Animation<double>? get animation => _animationController?.view;

  Duration get animationDuration => _animationDuration;

  int get index => _index;
  int _index;
  set index(int value) {
    _changeIndex(value);
  }

  int get previousIndex => _previousIndex;
  int _previousIndex;

  void attachListCallback(int count, double Function(int index) getSize) {
    _itemsCount += count;
    _getSizeCallback = getSize;
  }

  void animateToItem(int value, {Duration? duration, Curve curve = Curves.ease}) {
    _changeIndex(value, duration: duration ?? _animationDuration, curve: curve);
  }

  void jumpToItem(int value) {
    _changeIndex(value);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    super.dispose();
  }

  void _changeIndex(int value, {Duration? duration, Curve? curve}) {
    assert(
      value >= 0 && (value < _itemsCount || _itemsCount == 0),
      'Given index is out of range or there are no items',
    );
    assert(duration != null || curve == null, 'Duration given without curve');

    if (value == _index || _itemsCount < 2) {
      return;
    }
    _previousIndex = index;
    _index = value;

    final itemPosition = _getSizeCallback?.call(value - 1);

    if (itemPosition == null) {
      return;
    }

    if (duration != null && curve != null && duration > Duration.zero) {
      _animationController?.animateTo(_index.toDouble(), duration: duration, curve: curve);
      animateTo(itemPosition, duration: duration, curve: curve);
    } else {
      _animationController!.value = _index.toDouble();
      jumpTo(itemPosition);
    }
  }
}
