import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_status.g.dart';

// BALADY-3825: connectivity design.
//
// The previous implementation polled third-party hosts every 5 seconds for the
// whole app lifetime, and a single failed probe flipped the app-wide flag.
// That was both a false-negative source (those hosts are unrelated to our
// backend and may flake regionally) and a standing load problem: a 5-second
// heartbeat multiplied by the install base is a self-inflicted stress test on
// whoever is being probed.
//
// Now:
// - The OS interface state (connectivity_plus) is the trigger: no interface —
//   offline immediately with zero HTTP traffic; interface events start a probe.
// - One probe round asks our own backend (any HTTP response counts, 401
//   included — only reachability matters), the Balady portal, and a global
//   anchor; offline only if ALL of them fail.
// - While online there is NO periodic probing at all. While offline, retries
//   back off exponentially (5s → 60s cap) until connectivity returns.
@riverpod
class NetworkStatus extends _$NetworkStatus {
  static const _minRetryDelay = Duration(seconds: 5);
  static const _maxRetryDelay = Duration(seconds: 60);

  Timer? _retryTimer;
  Duration _retryDelay = _minRetryDelay;
  bool _probing = false;

  @override
  bool build() {
    final connectivitySubscription = Connectivity().onConnectivityChanged.listen(_onInterfaceChanged);
    ref.onDispose(() {
      connectivitySubscription.cancel();
      _retryTimer?.cancel();
    });
    update();
    return true;
  }

  /// Re-checks reachability now. Also wired to interface events and retries.
  Future<void> update() => _probe();

  void _onInterfaceChanged(List<ConnectivityResult> results) {
    final hasInterface = results.any((result) => result != ConnectivityResult.none);
    if (!hasInterface) {
      _retryTimer?.cancel();
      _retryDelay = _minRetryDelay;
      state = false;
      return;
    }
    _probe();
  }

  Future<void> _probe() async {
    if (_probing) {
      return;
    }
    _probing = true;
    try {
      final online = await _checker().hasInternetAccess;
      state = online;
      _retryTimer?.cancel();
      if (online) {
        _retryDelay = _minRetryDelay;
      } else {
        _retryTimer = Timer(_retryDelay, _probe);
        _retryDelay = _retryDelay * 2 > _maxRetryDelay ? _maxRetryDelay : _retryDelay * 2;
      }
    } finally {
      _probing = false;
    }
  }

  InternetConnection _checker() {
    // May be null before the environment config finishes loading — the portal
    // and the global anchor still cover that window.
    final backendUrl = ref.read(dgisEnvironmentProvider).value?.url;
    return InternetConnection.createInstance(
      useDefaultOptions: false,
      customCheckOptions: [
        if (backendUrl != null)
          InternetCheckOption(
            uri: Uri.parse(backendUrl),
            // Any HTTP response proves the network path works: the backend may
            // legitimately answer 4xx to an unauthenticated probe.
            responseStatusFn: (_) => true,
          ),
        InternetCheckOption(
          uri: Uri.parse('https://www.balady.gov.sa'),
          responseStatusFn: (_) => true,
        ),
        InternetCheckOption(uri: Uri.parse('https://one.one.one.one')),
      ],
    );
  }
}
