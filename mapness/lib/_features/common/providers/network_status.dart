import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_status.g.dart';

@riverpod
class NetworkStatus extends _$NetworkStatus {
  @override
  bool build() {
    final checker = InternetConnectionChecker.createInstance(
      checkInterval: const Duration(seconds: 5),
    );
    final connectivitySubscription = checker.onStatusChange.listen(_connectivityListener);
    ref.onDispose(connectivitySubscription.cancel);

    return true;
  }

  Future<void> update() async {
    state = await InternetConnectionChecker().hasConnection;
    ref.invalidateSelf();
  }

  void _connectivityListener(InternetConnectionStatus event) {
    state = event == InternetConnectionStatus.connected;
  }
}
