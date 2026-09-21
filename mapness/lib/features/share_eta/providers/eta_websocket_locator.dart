import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:mapness/features/share_eta/helpers/constants.dart';
import 'package:mapness/features/share_eta/models/eta_info_model.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:mapness/features/share_eta/models/ws_config.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

typedef ConnectionStatus = void Function({bool status});
typedef EtaInfoCallback<T> = void Function(EtaInfoModel<T> etaInfo);
typedef ConnectionLostCallback = void Function(int code, String reason);

class EtaWebsocket {
  static final EtaWebsocket _instance = EtaWebsocket._internal();

  factory EtaWebsocket() => _instance;

  EtaWebsocket._internal();

  final List<ConnectionStatus> _connectionStatusListeners = [];
  final List<EtaInfoCallback> _etaInfoListeners = [];
  final List<ConnectionLostCallback> _connectionLostListeners = [];

  static const _streamIdKey = 'stream_id';
  static const _geoStreamingTokenKey = 'GeoStreamingToken';
  static const _xStreamDataKey = 'X-Stream-Data';
  static const _reconnectingAttempts = 3;
  static const _connectionLostMonitorIntervalSec = 3;

  static const _pingIntervalSec = 10;

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
  Timer? _connectionLostMonitor;

  int? _lastErrorCode;

  void clearInfoListeners() {
    _etaInfoListeners.clear();
  }

  void clearConnectionStatusListeners() {
    _connectionStatusListeners.clear();
  }

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

  void addConnectionLostListener(ConnectionLostCallback listener) {
    _connectionLostListeners.add(listener);
  }

  void removeConnectionLostListener(ConnectionLostCallback listener) {
    _connectionLostListeners.remove(listener);
  }

  void _notifyConnectionLostListeners(int code, String reason) {
    if (_lastErrorCode == code) {
      return;
    }
    _lastErrorCode = code;

    for (final listener in _connectionLostListeners) {
      listener(code, reason);
    }
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

  Future<void> start({
    required String streamId,
    required String token,
    required String shareEtaApiUrl,
    SubscriptionType subscriptionType = SubscriptionType.get,
    String? xStreamData,
    WsConfig? config,
  }) async {
    _config =
        config ??
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

  Future<void> reconnect() async {
    /*
    Перед пере-подключением к серверу клиент **должен** подождать случайно
    выбранный промежуток времени. При последовательном повторном пере-подключении
    клиент **должен** использовать exponential backoff.

    Например, случайно выбрать число секунд между 0 и 5, и выполнить
    переподключение по истечение времени. При неудачном подключении
    выбрать число секунд между 5 и 10, и повторить действия повторно.
    */
    final random = Random();
    for (int i = 0; i < _reconnectingAttempts; i++) {
      try {
        final intervalStep = i == 0 ? 0 : 5 * i;

        final randomInterval = random.nextInt(5) + intervalStep;

        await Future.delayed(Duration(seconds: randomInterval));

        await _reconnect();
        return;
      } catch (e) {
        logger.log('Reconnecting attempt $i failed. Error: $e', logLevel: MapnessLogLevel.critical);
      }
      if (i == _reconnectingAttempts - 1) {
        throw Exception('Failed to reconnect');
      }
    }
  }

  Future<void> stop() async {
    await _stop();
  }

  Future<void> pushEtaInfo<T>(EtaInfoModel<T> etaInfo) async {
    if (_ws != null && _ws?.closeCode == null) {
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

  Future<void> _reconnect() async {
    await _start();
  }

  Future<void> _start() async {
    if (_config == null) {
      return;
    }

    await _stop(notify: false);

    _connectionLostMonitor = Timer.periodic(const Duration(seconds: _connectionLostMonitorIntervalSec), (timer) {
      if (_ws?.closeCode != null) {
        _notifyConnectionLostListeners(_ws!.closeCode!, _ws!.closeReason ?? '');
        timer.cancel();
      }
    });

    final config = _config!;

    final newUrl = Uri.tryParse(config.host);
    if (newUrl == null) {
      throw Exception('Invalid host');
    }

    final baseUrl = Uri(
      scheme: 'wss',
      host: newUrl.pathSegments.first,
      port: config.port,
      path: newUrl.hasEmptyPath ? _streamPath : newUrl.pathSegments.skip(1).join('/') + _streamPath,
      // We provide the streamId only for the subscription type
      queryParameters: config.subscriptionType == SubscriptionType.get
          ? {
              _streamIdKey: config.streamId,
            }
          : null,
    );

    try {
      final baseUrlString = baseUrl.toString();
      final headers = {
        _geoStreamingTokenKey: config.token,
      };
      if (config.xStreamData != null) {
        headers[_xStreamDataKey] = config.xStreamData!;
      }
      final socket = await WebSocket.connect(baseUrlString, headers: headers);
      _ws = socket;
      socket.pingInterval = const Duration(seconds: _pingIntervalSec);
      _lastErrorCode = null;
      _subscription = socket.listen(
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
            } else if (dataJsonType == 'geolocation') {
              _notifyEtaInfoListeners(
                EtaInfoModel.fromJson(
                  dataJson,
                  (json) => json == null ? null : EtaInfoPayload.fromJson(json as Map<String, dynamic>),
                ),
              );
              return;
            }
          } catch (e) {
            logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
          }
        },

        onError: (Object error) {
          logger.log('ETA websocket error: $error', logLevel: MapnessLogLevel.critical);
          unawaited(_handleUnexpectedClose(socket));
        },
        onDone: () => unawaited(_handleUnexpectedClose(socket)),
      );

      _notifyConnectionStatusListeners(true);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _stop({bool notify = true}) async {
    try {
      await _subscription?.cancel();
      await _ws?.close();
    } catch (e) {
      logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
    } finally {
      _ws = null;
      _subscription = null;
      _connectionLostMonitor?.cancel();
      _connectionLostMonitor = null;
      if (notify) {
        _notifyConnectionStatusListeners(false);
      }
    }
  }

  Future<void> _handleUnexpectedClose(WebSocket socket) async {
    if (!identical(socket, _ws)) {
      return;
    }

    final code = socket.closeCode ?? EtaErrorStatusCodes.connectionLost;
    final reason = socket.closeReason ?? '';

    await _stop();
    _notifyConnectionLostListeners(code, reason);
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
