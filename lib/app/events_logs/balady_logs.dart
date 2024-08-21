import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'package:balady_plus/app/events_logs/models/error_exception_model.dart';
import 'controller/logs_controller.dart';
import 'events_names.dart';

export 'models/error_exception_model.dart';
export 'controller/logs_controller.dart';
export 'events_names.dart';

void unhandledExceptionBaladyLogs(FutureOr<void> Function() main) async {
  FlutterError.onError = (FlutterErrorDetails details) {
    //this line prints the default flutter gesture caught exception in console
    //FlutterError.dumpErrorToConsole(details);
    print("Error From INSIDE FRAME_WORK");
    print("--------------------------------");
    print("Error :  ${details.exception}");
    print("StackTrace :  ${details.stack}");

    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.unhandledUIException,
        message: details.exception.toString(),
        stackTrace: details.stack.toString(),
      ),
    );
  };
  ////////////////////////////////////////////////////
  runZonedGuarded(
    () async {
      main();
    },
    (error, stackTrace) {
      // if (error is BadRequestException) {
      //   print("Response :  ${error.response}");
      // } else if (error is TypeError) {}
      print("Error FROM OUT_SIDE FRAMEWORK ");
      print("--------------------------------");
      print("Error :  $error");
      print("StackTrace :  $stackTrace");
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.unhandledAsynchronousException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    },
  );
}



String cURLRepresentation(RequestOptions options) {
  try{
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
