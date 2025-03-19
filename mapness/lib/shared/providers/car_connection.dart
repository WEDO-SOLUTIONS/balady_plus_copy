import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'map/dgis_controller.dart';

part 'car_connection.g.dart';

/// Getting car connection state (true/false) for Android Auto and CarPlay
@Riverpod(keepAlive: true)
class CarConnection extends _$CarConnection {
  @override
  Future<bool> build() async {
    _listenCarConnectionEvents();
    return _getCarConnectionState();
  }

  void _listenCarConnectionEvents() {
    final dgisController = ref.watch(dgisControllerProvider);
    final connectionSubscription = dgisController.value?.carConnectionEvents.listen((event) {
      state = AsyncValue.data(event);
    });
    ref.onDispose(() {
      connectionSubscription?.cancel();
    });
  }

  Future<bool> _getCarConnectionState() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    final connectionState = await dgisController.getCarConnectionState();
    state = AsyncValue.data(connectionState);
    return connectionState;
  }
}
