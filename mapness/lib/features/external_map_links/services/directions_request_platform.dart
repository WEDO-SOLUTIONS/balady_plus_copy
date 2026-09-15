// Cold-start-safe delivery of iOS directions requests, mirroring the app-icon
// quick-action platform layer.
//
// The same hand-off can reach us twice: the native side pushes it over the
// channel *and* keeps it in a pending slot that we poll on cold start and on
// every resume. Both paths share one dedupe window, so the routing page opens
// once; a delivered request is consumed natively so it cannot re-fire later.

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../shared/utils/logger/logger.dart';
import '../models/directions_request_payload.dart';
import '../models/external_map_link_intent.dart';
import 'directions_request_native_bridge.dart';

typedef ExternalDirectionsRequestHandler = Future<void> Function(ExternalMapDirectionsIntent intent);

/// Requests that arrived before `ProviderScope` mounted and the handler was
/// bound; flushed by [bindExternalDirectionsRequestHandler].
final List<ExternalMapDirectionsIntent> _earlyPending = <ExternalMapDirectionsIntent>[];
ExternalDirectionsRequestHandler? _requestHandler;
bool _bridgeInitialized = false;

String? _lastDispatchedKey;
DateTime? _lastDispatchedAt;

/// Window in which the native push and the pending-store poll are treated as
/// the same request.
const Duration _duplicateWindow = Duration(seconds: 3);

/// Destination and mode identify a hand-off: Apple Maps sends no request id.
String _dedupeKey(ExternalMapDirectionsIntent intent) {
  final destination = intent.destination;
  final point = destination is ExternalMapPlacePoint ? destination.point : null;
  return '${point?.latitude},${point?.longitude},${intent.mode.name}';
}

void _rememberDispatch(String key) {
  _lastDispatchedKey = key;
  _lastDispatchedAt = DateTime.now();
}

bool _shouldIgnoreDuplicateDispatch(String key) {
  final lastAt = _lastDispatchedAt;
  if (_lastDispatchedKey == key && lastAt != null && DateTime.now().difference(lastAt) < _duplicateWindow) {
    return true;
  }
  _rememberDispatch(key);
  return false;
}

Future<void> _dispatchRequest(ExternalMapDirectionsIntent intent) async {
  final key = _dedupeKey(intent);
  final handler = _requestHandler;
  if (handler != null && _shouldIgnoreDuplicateDispatch(key)) {
    _logBridge('ignoring duplicate directions request: $key');
    return;
  }

  _logBridge('directions request received: $key');
  if (handler == null) {
    if (!_earlyPending.any((queued) => _dedupeKey(queued) == key)) {
      _earlyPending.add(intent);
      _rememberDispatch(key);
    }
    _logBridge('queued directions request (handler not bound yet): $key');
    return;
  }

  await _runHandler(handler, intent);
}

Future<void> _runHandler(ExternalDirectionsRequestHandler handler, ExternalMapDirectionsIntent intent) async {
  try {
    await handler(intent);
  } catch (e, st) {
    _logBridge('handler failed: $e\n$st');
  }
  // Always clear the native slot after a dispatch: a launch payload left in it
  // would open the routing page again on the next resume.
  await DirectionsRequestNativeBridge.consumePending();
}

/// Binds the native channel. Safe to call more than once.
Future<void> initExternalDirectionsRequestBridge() async {
  if (_bridgeInitialized) {
    return;
  }
  _bridgeInitialized = true;

  DirectionsRequestNativeBridge.setMethodCallHandler((payload) async {
    final intent = externalDirectionsIntentFromNative(payload);
    if (intent == null) {
      _logBridge('ignoring directions request without a usable destination');
      return;
    }
    await _dispatchRequest(intent);
  });

  _logBridge('bridge initialized');
}

/// Wires the Riverpod-backed handler and flushes requests that arrived first.
void bindExternalDirectionsRequestHandler(ExternalDirectionsRequestHandler handler) {
  _requestHandler = handler;
  if (_earlyPending.isEmpty) {
    return;
  }
  final pending = List<ExternalMapDirectionsIntent>.from(_earlyPending);
  _earlyPending.clear();
  scheduleMicrotask(() async {
    for (final intent in pending) {
      _logBridge('flushing queued directions request: ${_dedupeKey(intent)}');
      await _runHandler(handler, intent);
    }
  });
}

/// Delivers a request the native side stored for us — used on cold start (the
/// scene may have opened the URL before Dart was listening) and on resume.
Future<void> deliverPendingExternalDirectionsRequest() async {
  final payload = await DirectionsRequestNativeBridge.peekPending();
  if (payload == null) {
    return;
  }

  final intent = externalDirectionsIntentFromNative(payload);
  if (intent == null) {
    _logBridge('dropping pending directions request without a usable destination');
    await DirectionsRequestNativeBridge.consumePending();
    return;
  }

  _logBridge('pending directions request found');
  await _dispatchRequest(intent);
}

void _logBridge(String message) {
  if (kDebugMode) {
    debugPrint('ExternalDirections: $message');
  }
  try {
    logger.log('ExternalDirections: $message');
  } catch (_) {
    // Logger may not be ready yet during app start-up.
  }
}
