import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_status.g.dart';

@riverpod
class NetworkStatus extends _$NetworkStatus {
  InternetConnection? _checker;

  @override
  bool build() {
    update();
    final checker = InternetConnection.createInstance(
      checkInterval: const Duration(seconds: 5),
    );
    _checker = checker;
    final connectivitySubscription = checker.onStatusChange.listen(_connectivityListener);

    ref.onDispose(connectivitySubscription.cancel);

    return true;
  }

  Future<void> update() async {
    state = await InternetConnection().hasInternetAccess;
  }

  // BALADY-3825: `onStatusChange` polls a handful of third-party hosts that are
  // unrelated to our own backend, so a single failed probe (slow DNS, brief
  // handover) can report `disconnected` even though the device is online and
  // the app's own requests succeed. That false reading used to flip this
  // provider immediately, hiding search (and every other screen gated on it)
  // behind a "no internet" error. Re-confirm with a fresh check before
  // trusting a disconnected reading; recover immediately on a connected one.
  Future<void> _connectivityListener(InternetStatus event) async {
    if (event == InternetStatus.connected) {
      state = true;
      return;
    }
    state = await _checker?.hasInternetAccess ?? false;
  }
}
