import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mapness/features/share_eta/models/eta_info_model.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:mapness/features/share_eta/models/ws_config.dart';
import 'package:mapness/features/share_eta/providers/websocket_status_provider.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'eta_websocket_provider.g.dart';

@Riverpod(keepAlive: true)
class EtaWebsocket extends _$EtaWebsocket {
  WsConfig? _config;

  final defaultConfig = const WsConfig(
    host: '',
    port: 443,
    token: '',
    streamId: '',
    subscriptionType: SubscriptionType.get,
  );

  StreamSubscription? _subscription;
  WebSocket? _ws;

  @override
  Future<EtaInfoModel?> build() async {
    ref.onDispose(() {
      stop();
    });
    return null;
  }

  Future<void> start({
    required String streamId,
    required String token,
    SubscriptionType subscriptionType = SubscriptionType.get,
    String? estimatedTime,
    String? xStreamData,
    WsConfig? config,
  }) async {
    final envProvider = await ref.read(dgisEnvironmentProvider.future);
    _config = config ??
        defaultConfig.copyWith(
          subscriptionType: subscriptionType,
          streamId: streamId,
          token: token,
          xStreamData: xStreamData,
          estimatedTime: estimatedTime,
          host: envProvider.shareEtaApi.replaceAll(RegExp(r'https?://'), ''),
        );
    await _start();
  }

  Future<void> stop() async {
    state = const AsyncValue.data(null);
    await _stop();
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
    if (_config == null) {
      return;
    }

    await _stop();

    final config = _config!;

    final baseUrl = Uri(
      scheme: 'wss',
      host: config.host,
      port: config.port,
      path: _streamPath,
      // We provide the streamId only for the subscription type
      queryParameters: config.subscriptionType == SubscriptionType.get
          ? {
              'streamId': config.streamId,
            }
          : null,
    );

    try {
      final baseUrlString = baseUrl.toString();
      _ws = await WebSocket.connect(baseUrlString, headers: {
        'GeoStreamingToken': config.token,
        'X-Stream-Data': config.xStreamData,
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

      ref.read(websocketStatusProvider.notifier).setConnected(
            streamId: config.streamId,
            streamToken: config.token,
          );
      final estimateTime = config.dateTimeEstimatedTime;
      if (estimateTime != null) {
        ref.read(websocketStatusProvider.notifier).setEstimatedTime(estimateTime);
      }
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
      ref.read(websocketStatusProvider.notifier).setDisconnected();
    }
  }

  String get _streamPath {
    if (_config == null) {
      return '';
    }
    final config = _config!;

    switch (config.subscriptionType) {
      case SubscriptionType.share:
        return '/v1/geolocation/stream/start';
      case SubscriptionType.get:
        return '/v1/geolocation/stream/subscribe';
      case SubscriptionType.custom:
        return config.customPath!;
    }
  }
}
