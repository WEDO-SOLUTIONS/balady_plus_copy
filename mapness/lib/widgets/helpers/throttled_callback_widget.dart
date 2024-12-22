import 'package:flutter/material.dart';

class ThrottledCallbackWidget extends StatefulWidget {
  final Duration throttleDuration;
  final VoidCallback callback;
  final Widget Function(BuildContext context, VoidCallback callback) builder;

  const ThrottledCallbackWidget({
    required this.builder,
    required this.callback,
    this.throttleDuration = const Duration(seconds: 1),
    super.key,
  });

  @override
  State<ThrottledCallbackWidget> createState() => _ThrottledCallbackWidgetState();
}

class _ThrottledCallbackWidgetState extends State<ThrottledCallbackWidget> {
  DateTime? _lastCall;

  @override
  Widget build(BuildContext context) => widget.builder(context, _callback);

  void _callback() {
    if (_lastCall != null &&
        DateTime.now().difference(_lastCall!).inMilliseconds < widget.throttleDuration.inMilliseconds) {
      return;
    }

    _lastCall = DateTime.now();
    widget.callback();
  }
}
