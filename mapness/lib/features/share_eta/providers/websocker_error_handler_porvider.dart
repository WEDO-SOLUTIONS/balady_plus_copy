import 'dart:convert';

import 'package:mapness/features/share_eta/providers/eta_websocket_locator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websocker_error_handler_porvider.g.dart';

enum WebsocketReason {
  expired,
  manual,
}

extension WebSocketReasonX on String {
  WebsocketReason? toWebsocketReason() {
    switch (this) {
      case 'expired':
        return WebsocketReason.expired;
      case 'manual':
        return WebsocketReason.manual;
      default:
        return null;
    }
  }
}

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
    String? reasonJson;
    if (reason != null && reason.isNotEmpty) {
      try {
        final json = jsonDecode(reason) as Map<String, dynamic>;
        reasonJson = json['reason'];
      } catch (e) {
        reasonJson = null;
      }
    }

    state = (code, reasonJson);
  }
}
