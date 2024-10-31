import 'dart:async';
import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'map/dgis_controller.dart';

part 'car_connection.g.dart';

/// Getting car connection state (true/false) for Android Auto and CarPlay
@riverpod
class CarConnection extends _$CarConnection {
  @override
  Future<bool> build() async {
    // TODO(Sergei): implement CarPlay connection logic
    if (Platform.isAndroid) {
      _listenAndroidAutoConnectionEvents();
      return _getAndroidAutoConnectionState();
    } else {
      return false;
    }
  }

  void _listenAndroidAutoConnectionEvents() {
    final dgisController = ref.watch(dgisControllerProvider);
    final connectionSubscription = dgisController.value?.androidAutoConnectionEvents.listen((event) {
      state = AsyncValue.data(event);
    });
    ref.onDispose(() {
      connectionSubscription?.cancel();
    });
  }

  Future<bool> _getAndroidAutoConnectionState() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    final connectionState = await dgisController.getAndroidAutoConnectionState();
    state = AsyncValue.data(connectionState);
    return connectionState;
  }
}
