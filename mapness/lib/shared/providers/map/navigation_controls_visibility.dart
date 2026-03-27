import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationControlsVisibilityProvider = NotifierProvider<NavigationControlsVisibility, bool>(
  NavigationControlsVisibility.new,
);

class NavigationControlsVisibility extends Notifier<bool> {
  static const _autoHideDelay = Duration(seconds: 5);
  Timer? _hideTimer;

  @override
  bool build() {
    ref.onDispose(() {
      _hideTimer?.cancel();
    });
    return false;
  }

  void registerInteraction() {
    if (!state) {
      state = true;
    }

    _hideTimer?.cancel();
    _hideTimer = Timer(_autoHideDelay, () {
      state = false;
    });
  }
}
