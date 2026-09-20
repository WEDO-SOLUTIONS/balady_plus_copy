import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:balady_plus/app/events_logs/models/error_exception_model.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';

import 'controller/logs_controller.dart';
import 'events_names.dart';

export 'models/error_exception_model.dart';
export 'controller/logs_controller.dart';
export 'events_names.dart';

/// Session budget per error fingerprint (type + first message line). This is
/// the single line where every unawaited async error becomes a billable
/// PostHog event; without a cap one leaked Future in a hot path is a quota
/// incident (measured: 619k handled events/week, 91% of all traffic, from a
/// handful of such bugs). First occurrences always report; a flood becomes a
/// 5-events-per-10-minutes blip.
const _maxReportsPerFingerprint = 5;
const _reportWindow = Duration(minutes: 10);
final Map<String, (int, DateTime)> _reportBudget = {};

/// Known-noise: errors we cannot reach from app code (library-internal
/// fire-and-forget Futures and GC finalizers) whose per-event value is zero.
/// Counted and flushed as a single `track` per session-ish window instead.
final Map<String, int> _droppedNoise = {};
DateTime? _lastNoiseFlush;

bool _isKnownNoise(Object error) {
  final text = error.toString();
  // wkwebview pigeon channels torn down on the shared engine (BALADY-3942):
  // emitted from plugin constructors and a GC Finalizer - unreachable from
  // app code by design.
  if (text.contains('dev.flutter.pigeon.webview_flutter_wkwebview')) {
    return true;
  }
  // Broken server SVG re-fails from flutter_svg's permanently cached
  // rejection on every rebuild (BALADY-3940 adds the widget-side blocklist).
  if (text.contains('Invalid SVG data')) {
    return true;
  }
  return false;
}

bool _shouldReport(Object error) {
  if (_isKnownNoise(error)) {
    final key = error.runtimeType.toString();
    _droppedNoise[key] = (_droppedNoise[key] ?? 0) + 1;
    final now = DateTime.now();
    if (_lastNoiseFlush == null || now.difference(_lastNoiseFlush!) > _reportWindow) {
      _lastNoiseFlush = now;
      BaladyAnalytics.instance.track('suppressed_noise_errors', properties: Map.of(_droppedNoise));
      _droppedNoise.clear();
    }
    return false;
  }

  // Fingerprint on type + first message line: full messages defeat the dedup
  // (localized/URL tails), the first line groups like PostHog does.
  final firstLine = error.toString().split('\n').first;
  final key = '${error.runtimeType}:${firstLine.hashCode}';
  final now = DateTime.now();
  final entry = _reportBudget[key];
  if (entry == null || now.difference(entry.$2) > _reportWindow) {
    _reportBudget[key] = (1, now);
    return true;
  }
  if (entry.$1 >= _maxReportsPerFingerprint) {
    return false;
  }
  _reportBudget[key] = (entry.$1 + 1, entry.$2);
  return true;
}

Future<void> unhandledExceptionBaladyLogs(FutureOr<void> Function() main) async {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      // Prints the full diagnostics, not just exception + stack. For rendering
      // errors that is the only place the offending RenderObject and the widget
      // that created it show up (`details.context`, `details.library` and
      // `informationCollector`); printing the two fields below alone throws
      // that away and leaves every framework error unattributable.
      // `forceReport: true` matters: without it Flutter prints the full dump
      // only for the *first* error of the session and collapses every later
      // one to "Another exception was thrown: ...", which drops the widget
      // and creator chain - the only parts that identify the culprit.
      FlutterError.dumpErrorToConsole(details, forceReport: true);
    }
    _debugLog('Error From INSIDE FRAME_WORK');
    _debugLog('--------------------------------');
    _debugLog('Error :  ${details.exception}');
    _debugLog('StackTrace :  ${details.stack}');

    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.unhandledUIException,
        message: details.exception.toString(),
        stackTrace: details.stack.toString(),
      ),
    );
  };
  ////////////////////////////////////////////////////
  final guardedFuture = runZonedGuarded<Future<void>>(
    () async {
      await main();
    },
    (error, stackTrace) {
      // if (error is BadRequestException) {
      //   print("Response :  ${error.response}");
      // } else if (error is TypeError) {}
      _debugLog('Error FROM OUT_SIDE FRAMEWORK ');
      _debugLog('--------------------------------');
      _debugLog('Error :  $error');
      _debugLog('StackTrace :  $stackTrace');
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.unhandledAsynchronousException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      // The one crash path PostHog's autocapture cannot reach: a zone handler
      // swallows async errors before they surface to PlatformDispatcher, and a
      // zone cannot be hooked from outside. Framework and native crashes need
      // no call here — the SDK captures those itself and chains our handlers.
      // Fires before `configure()` on early startup crashes; the facade buffers
      // and flushes them once the mode is known.
      if (_shouldReport(error)) {
        BaladyAnalytics.instance.error(error, stackTrace, {'mechanism': 'runZonedGuarded'});
      }
    },
  );

  if (guardedFuture != null) {
    await guardedFuture;
  }
}

void _debugLog(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}

String cURLRepresentation(RequestOptions options) {
  try {
    List<String> components = ['curl -i'];
    if (options.method.toUpperCase() != 'GET') {
      components.add('-X ${options.method}');
    }

    options.headers.forEach((k, v) {
      if (k != 'Cookie') {
        components.add('-H "$k: $v"');
      }
    });

    if (options.data != null) {
      // FormData can't be JSON-serialized, so keep only their fields attributes
      if (options.data is FormData) {
        options.data = Map.fromEntries(options.data.fields);
      }

      final data = json.encode(options.data).replaceAll('"', '\\"');
      components.add('-d "$data"');
    }

    components.add('"${options.uri.toString()}"');

    return components.join(' \\\n\t');
  } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
    return "";
  }
}
