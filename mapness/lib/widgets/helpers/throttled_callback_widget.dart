import 'dart:async';

import 'package:flutter/material.dart';

class ThrottledCallbackWidget extends StatefulWidget {
  final Duration throttleDuration;
  final FutureOr<void> Function() callback;

  /// If [resetAfterFutureCompleted] is true - then throttle will be reset
  /// after receiving resulted future of [callback] is completed
  /// Also it will be ignore [throttleDuration] if [resetAfterFutureCompleted] is true
  /// Default value is false
  final bool resetAfterFutureCompleted;
  final Widget Function(BuildContext context, VoidCallback callback) builder;

  const ThrottledCallbackWidget({
    required this.builder,
    required this.callback,
    this.throttleDuration = const Duration(seconds: 1),
    this.resetAfterFutureCompleted = false,
    super.key,
  });

  @override
  State<ThrottledCallbackWidget> createState() => _ThrottledCallbackWidgetState();
}

class _ThrottledCallbackWidgetState extends State<ThrottledCallbackWidget> {
  DateTime? _lastCall;
  bool inProgress = false;

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        _callback,
      );

  Future<void> _callback() async {
    if (!widget.resetAfterFutureCompleted &&
        _lastCall != null &&
        DateTime.now().difference(_lastCall!) < widget.throttleDuration) {
      return;
    }

    if (widget.resetAfterFutureCompleted && inProgress) {
      return;
    }

    _lastCall = DateTime.now();
    inProgress = true;

    await widget.callback();
    inProgress = false;
  }
}
