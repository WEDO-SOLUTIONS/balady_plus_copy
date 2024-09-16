import 'package:mapness/features/share_eta/providers/eta_websocket_locator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websocker_error_handler_porvider.g.dart';

@Riverpod(keepAlive: true)
class WebsocketErrorHandler extends _$WebsocketErrorHandler {
  @override
  (int?, String?) build() {
    EtaWebsocket().addConnectionLostListener(setStatus);
    ref.onDispose(() {
      EtaWebsocket().removeConnectionLostListener(setStatus);
    });
    return (null, null);
  }

  void setStatus(int? code, String? reason) {
    state = (code, reason);
  }
}
