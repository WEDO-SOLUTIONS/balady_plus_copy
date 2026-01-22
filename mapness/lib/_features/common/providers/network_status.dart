import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_status.g.dart';

@riverpod
class NetworkStatus extends _$NetworkStatus {
  @override
  bool build() {
    update();
    final checker = InternetConnection.createInstance(
      checkInterval: const Duration(seconds: 5),
    );
    final connectivitySubscription = checker.onStatusChange.listen(_connectivityListener);

    ref.onDispose(connectivitySubscription.cancel);

    return true;
  }

  Future<void> update() async {
    state = await InternetConnection().hasInternetAccess;
  }

  void _connectivityListener(InternetStatus event) {
    state = event == InternetStatus.connected;
  }
}
