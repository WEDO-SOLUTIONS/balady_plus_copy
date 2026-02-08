import 'dart:async';
import 'package:flutter/material.dart';

import 'counter.dart';

class AnimatedCounter extends StatefulWidget {
  final Color? color;
  final int? count;
  final CounterType type;
  final CounterColorScheme colorScheme;

  const AnimatedCounter({
    this.color,
    this.count,
    this.type = CounterType.text,
    this.colorScheme = CounterColorScheme.accent,
    Key? key,
  }) : super(key: key);

  @override
  _AnimatedCounterState createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> {
  late ValueNotifier<int> _counterNotifier;
  late Timer _timer;
  int _repeatCount = 0;

  @override
  void initState() {
    super.initState();
    _counterNotifier = ValueNotifier<int>(0);
    _timer = Timer.periodic(const Duration(milliseconds: 30), _updateCounter);
  }

  @override
  void dispose() {
    _timer.cancel();
    _counterNotifier.dispose();
    super.dispose();
  }

  void _updateCounter(Timer timer) {
    setState(() {
      if (_repeatCount < 3) {
        if (_counterNotifier.value < 1200) {
          _counterNotifier.value += 1;
        } else {
          _counterNotifier.value = 0;
          _repeatCount++;
          if (_repeatCount == 3) {
            _counterNotifier.value = 1000;
            _timer.cancel();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
        valueListenable: _counterNotifier,
        builder: (context, value, child) => Counter(
          count: widget.count != null ? value : widget.count,
          color: widget.color,
        ),
      );
}
