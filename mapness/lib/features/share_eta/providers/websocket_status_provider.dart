import 'package:mapness/features/share_eta/providers/eta_websocket_locator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websocket_status_provider.g.dart';

@Riverpod(keepAlive: true)
class WebsocketStatus extends _$WebsocketStatus {
  @override
  bool build() {
    EtaWebsocket().addConnectionStatusListener(setStatus);

    ref.onDispose(() {
      EtaWebsocket().removeConnectionStatusListener(setStatus);
    });

    return false;
  }

  void setStatus({bool? status}) {
    state = status ?? false;
  }
}
