import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mapness/features/share_eta/models/eta_info_model.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:mapness/features/share_eta/models/ws_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'eta_websocket_provider.g.dart';

@riverpod
class EtaWebsocketProvider extends _$EtaWebsocketProvider {
  final WsConfig _config;

  StreamSubscription? _subscription;
  WebSocket? _ws;

  EtaWebsocketProvider(this._config);

  @override
  Future<EtaInfoModel?> build() async {
    await _start();
    ref.onDispose(_stop);
    return null;
  }

  Future<void> pushEtaInfo<T>(EtaInfoModel<T> etaInfo) async {
    if (_ws != null) {
      final toJsonFunc = switch (T) {
        EtaInfoPayload => (json) => json == null ? null : EtaInfoPayload.fromJson(json as Map<String, dynamic>),
        EtaRoutePayload => (json) => json == null ? null : EtaRoutePayload.fromJson(json as Map<String, dynamic>),
        _ => null,
      };
      if (toJsonFunc == null) {
        state = AsyncError(Exception('Unsupported type'), StackTrace.current);
        return;
      }
      // Send data to the server
      _ws?.add(jsonEncode(etaInfo.toJson(toJsonFunc)));
    } else {
      state = AsyncError(Exception('WebSocket is not connected'), StackTrace.current);
    }
  }

  Future<void> _start() async {
    await _stop();
    final baseUrl = Uri(
      scheme: 'ws',
      host: _config.host,
      port: _config.port,
      path: _streamPath,
      queryParameters: {
        'streamId': _config.streamId,
      },
    );

    try {
      _ws = await WebSocket.connect(baseUrl.toString(), headers: {
        'Connection': 'upgrade',
        'Upgrade': 'websocket',
        'GeoStreamingToken': _config.token,
      });
      _subscription = _ws?.listen(
        (data) {
          try {
            final dataJson = jsonDecode(data);
            // ignore: avoid_dynamic_calls
            final dataJsonType = dataJson['type'] as String?;

            if (dataJsonType == 'stream_metadata') {
              state = AsyncData(
                EtaInfoModel.fromJson(
                  dataJson,
                  (json) => json == null ? null : EtaRoutePayload.fromJson(json as Map<String, dynamic>),
                ),
              );
              return;
            } else if (dataJsonType != 'geolocation') {
              state = AsyncData(
                EtaInfoModel.fromJson(
                  dataJson,
                  (json) => json == null ? null : EtaInfoPayload.fromJson(json as Map<String, dynamic>),
                ),
              );
              return;
            }
          } catch (e, s) {
            state = AsyncError(e, s);
          }
        },
        onDone: _stop,
        // First iteration we don't need to handle errors
        onError: (error) => _stop(),
      );
    } catch (e, s) {
      state = AsyncError(e, s);
      return;
    }
  }

  Future<void> _stop() async {
    try {
      await _subscription?.cancel();
      await _ws?.close();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _ws = null;
      _subscription = null;
    }
  }

  String get _streamPath {
    switch (_config.subscriptionType) {
      case SubscriptionType.share:
        return '/v1/geolocation/stream/start';
      case SubscriptionType.get:
        return '/v1/geolocation/stream/subscribe';
      case SubscriptionType.custom:
        return _config.customPath!;
    }
  }
}
