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
      BaladyAnalytics.instance.error(error, stackTrace, {'mechanism': 'runZonedGuarded'});
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
