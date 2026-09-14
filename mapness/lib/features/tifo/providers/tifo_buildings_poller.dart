import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/providers/tifo_buildings_provider.dart';
import 'package:mapness/shared/utils/detach.dart';

/// Long-poll service for building state. While running it periodically asks the
/// buildings provider to refresh ownership/status of the visible set
/// (`POST /buildings/by-ids`) — so the map picks up takeovers/cooldowns without
/// re-fetching geometry. The map layer owns its lifecycle (start on enable,
/// stop on disable); the diff → pointwise polygon redraw happens in the layer
/// off the provider update.
class TifoBuildingsPoller extends Notifier<bool> {
  Timer? _timer;

  /// Slightly faster than the server's 30s summary cache (NFR §7).
  static const Duration _interval = Duration(seconds: 20);

  @override
  bool build() {
    ref.onDispose(_stop);
    return false;
  }

  void start() {
    if (_timer != null) {
      return;
    }
    state = true;
    _timer = Timer.periodic(_interval, (_) {
      detach(ref.read(tifoBuildingsProvider.notifier).refreshVisible(), tag: 'tifoBuildingsPoller.refreshVisible');
    });
  }

  void stop() => _stop();

  void _stop() {
    _timer?.cancel();
    _timer = null;
    if (state) {
      state = false;
    }
  }
}

final tifoBuildingsPollerProvider = NotifierProvider<TifoBuildingsPoller, bool>(TifoBuildingsPoller.new);
