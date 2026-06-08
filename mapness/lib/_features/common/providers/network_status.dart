import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_status.g.dart';

// How long a disconnection must persist before the UI shows the no-internet state.
// Covers brief 5G→4G handoffs that typically recover within 1–2 s.
const _disconnectGracePeriod = Duration(seconds: 5);

@riverpod
class NetworkStatus extends _$NetworkStatus {
  Timer? _disconnectTimer;

  @override
  bool build() {
    update();
    final checker = InternetConnection.createInstance(
      checkInterval: const Duration(seconds: 5),
    );
    final connectivitySubscription = checker.onStatusChange.listen(_connectivityListener);

    ref.onDispose(() {
      connectivitySubscription.cancel();
      _disconnectTimer?.cancel();
    });

    return true;
  }

  Future<void> update() async {
    state = await InternetConnection().hasInternetAccess;
  }

  void _connectivityListener(InternetStatus event) {
    if (event == InternetStatus.connected) {
      // Restore immediately — no need to wait.
      _disconnectTimer?.cancel();
      state = true;
    } else {
      // Don't flip to offline instantly. Re-verify after the grace period so
      // transient handoffs (5G→4G, Wi-Fi roaming) don't disrupt the current view.
      _disconnectTimer?.cancel();
      _disconnectTimer = Timer(_disconnectGracePeriod, () async {
        final stillOffline = !await InternetConnection().hasInternetAccess;
        if (stillOffline) {
          state = false;
        }
      });
    }
  }
}
