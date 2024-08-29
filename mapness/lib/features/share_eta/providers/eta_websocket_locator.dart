import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mapness/features/share_eta/models/eta_info_model.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:mapness/features/share_eta/models/ws_config.dart';

typedef ConnectionStatus = void Function({bool status});
typedef EtaInfoCallback<T> = void Function(EtaInfoModel<T> etaInfo);

class EtaWebsocket {
  static final EtaWebsocket _instance = EtaWebsocket._internal();

  factory EtaWebsocket() => _instance;

  EtaWebsocket._internal();

  final List<ConnectionStatus> _connectionStatusListeners = [];
  final List<EtaInfoCallback> _etaInfoListeners = [];

  void addConnectionStatusListener(ConnectionStatus listener) {
    _connectionStatusListeners.add(listener);
  }

  void removeConnectionStatusListener(ConnectionStatus listener) {
    _connectionStatusListeners.remove(listener);
  }

  void addEtaInfoListener(EtaInfoCallback listener) {
    _etaInfoListeners.add(listener);
  }

  void removeEtaInfoListener(EtaInfoCallback listener) {
    _etaInfoListeners.remove(listener);
  }

  void _notifyConnectionStatusListeners(bool status) {
    for (final listener in _connectionStatusListeners) {
      listener(status: status);
    }
  }

  void _notifyEtaInfoListeners<T>(EtaInfoModel<T> etaInfo) {
    for (final listener in _etaInfoListeners) {
      listener(etaInfo);
    }
  }

  static const _streamIdKey = 'streamId';
  static const _geoStreamingTokenKey = 'GeoStreamingToken';
  static const _xStreamDataKey = 'X-Stream-Data';

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

  Future<void> start({
    required String streamId,
    required String token,
    required String shareEtaApiUrl,
    SubscriptionType subscriptionType = SubscriptionType.get,
    String? xStreamData,
    WsConfig? config,
  }) async {
    _config = config ??
        defaultConfig.copyWith(
          subscriptionType: subscriptionType,
          streamId: streamId,
          token: token,
          xStreamData: xStreamData,
          // Remove the protocol from the host
          host: shareEtaApiUrl.replaceAll(RegExp(r'https?://'), ''),
        );
    await _start();
  }

  Future<void> stop() async {
    await _stop();
  }

  Future<void> pushEtaInfo<T>(EtaInfoModel<T> etaInfo) async {
    if (_ws != null) {
      final toJsonFunc = switch (T) {
        EtaInfoPayload => (object) => object == null ? null : (object as EtaInfoPayload).toJson(),
        EtaRoutePayload => (object) => object == null ? null : (object as EtaRoutePayload).toJson(),
        _ => null,
      };
      if (toJsonFunc == null) {
        throw Exception('Unsupported type');
      }
      // Send data to the server
      final jsonData = jsonEncode(etaInfo.toJson(toJsonFunc));
      _ws?.add(jsonData);
    } else {
      throw Exception('WebSocket is not connected');
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
              _streamIdKey: config.streamId,
            }
          : null,
    );

    try {
      final baseUrlString = baseUrl.toString();
      _ws = await WebSocket.connect(baseUrlString, headers: {
        _geoStreamingTokenKey: config.token,
        _xStreamDataKey: config.xStreamData,
      });
      _subscription = _ws?.listen(
        (data) {
          try {
            final dataJson = jsonDecode(data);
            // ignore: avoid_dynamic_calls
            final dataJsonType = dataJson['type'] as String?;

            if (dataJsonType == 'stream_metadata') {
              _notifyEtaInfoListeners(
                EtaInfoModel.fromJson(
                  dataJson,
                  (json) => json == null ? null : EtaRoutePayload.fromJson(json as Map<String, dynamic>),
                ),
              );
              return;
            } else if (dataJsonType != 'geolocation') {
              _notifyEtaInfoListeners(
                EtaInfoModel.fromJson(
                  dataJson,
                  (json) => json == null ? null : EtaInfoPayload.fromJson(json as Map<String, dynamic>),
                ),
              );
              return;
            }
          } catch (e) {
            // state = AsyncError(e, s);
          }
        },

        // onDone: () {
        //   print('done');
        //   _stop;
        // },
        // First iteration we don't need to handle errors
        onError: (error) {
          debugPrint(error.toString());
          return _stop();
        },
      );

      _notifyConnectionStatusListeners(true);
    } catch (e) {
      rethrow;
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
      _notifyConnectionStatusListeners(false);
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
