import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_status.g.dart';

@riverpod
class NetworkStatus extends _$NetworkStatus {
  @override
  ConnectivityResult build() {
    final connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_connectivityListener);
    ref.onDispose(connectivitySubscription.cancel);

    return ConnectivityResult.other;
  }

  // ignore: use_setters_to_change_properties
  void _connectivityListener(ConnectivityResult event) {
    state = event;
  }
}
