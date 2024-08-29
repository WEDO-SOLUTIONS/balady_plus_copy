import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websocket_status_provider.g.dart';

@riverpod
class WebsocketStatus extends _$WebsocketStatus {
  @override
  bool build() => false;

  void setConnected() {
    state = true;
  }

  void setDisconnected() {
    state = false;
  }
}
