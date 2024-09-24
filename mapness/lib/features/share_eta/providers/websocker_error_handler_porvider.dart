import 'dart:convert';

import 'package:mapness/features/share_eta/providers/eta_websocket_locator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websocker_error_handler_porvider.g.dart';

enum WebsocketReason {
  expired,
  manual,
  noData,
}

extension WebsocketReasonX on WebsocketReason {
  String toName() {
    switch (this) {
      case WebsocketReason.expired:
        return 'expired';
      case WebsocketReason.manual:
        return 'manual';
      case WebsocketReason.noData:
        return 'no_data';
    }
  }
}

extension WebSocketReasonX on String {
  WebsocketReason? toWebsocketReason() {
    switch (this) {
      case 'expired':
        return WebsocketReason.expired;
      case 'manual':
        return WebsocketReason.manual;
      case 'no_data':
        return WebsocketReason.noData;
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
    final (currentCode, _) = state;
    if (currentCode == code) {
      return;
    }
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
