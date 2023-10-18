import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  Debouncer({required this.milliseconds});

  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  bool get isActive => _timer != null && (_timer?.isActive ?? false);

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(
      Duration(milliseconds: milliseconds),
      () {
        action();
        _timer = null;
      },
    );
  }

  void dispose() {
    _timer?.cancel();
  }
}
