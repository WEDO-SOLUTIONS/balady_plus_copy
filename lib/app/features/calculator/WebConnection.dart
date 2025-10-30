import 'dart:convert';
import 'dart:io';
import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/features/calculator/presentation/pages/presenter/ServiceCalculatorPresenter.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class WebServiceConnections {
  final String API_URL = RemoteConfig.baladyBaseUrl + '/apis/v1.0/Lookup/';

// calculator
  final String CALCULATOR_API =
      RemoteConfig.baladyBaseUrl + "/Eservices/FeesCalculator";

  //////===========================
  final String METHOD_TYPE_GET = "get";

  Future<Map<String, dynamic>> sendGetRequest(
      {String? url, Map<String, String>? headers, String? apiName}) async {
    try {
      final response = await http.get(Uri.parse(url ?? ""), headers: headers);
      // //print(response.body);
      if (response.statusCode == HttpStatus.ok ||
          (response.statusCode == HttpStatus.accepted)) {
        ////print("OKKK");
        Map<String, dynamic> m = new Map();
        m.putIfAbsent("state", () => true);
        m.putIfAbsent("StatusCode", () => response.statusCode);
        m.putIfAbsent("path", () => url);
        m.putIfAbsent('data', () => response.body.toString());
        m.putIfAbsent("RelativePath", () => url);

        return m;
      } else {
        Map<String, dynamic> m = new Map();
        m.putIfAbsent("state", () => false);
        m.putIfAbsent("StatusCode", () => response.statusCode);
        m.putIfAbsent("path", () => url);
        m.putIfAbsent("RelativePath", () => url);
        m.putIfAbsent(
            'data',
            () => (response != null && response.body != null)
                ? response.body.toString()
                : null);

        try {
          Helpers.sendLog(
              url: url,
              data: apiName,
              errorMsg: (response != null && response.body != null)
                  ? response.body.toString()
                  : "");
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

        return m;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      //print(error);
      if (error != null) {
        try {
          Helpers.sendLog(url: url, errorMsg: error.toString());
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw APIException(apiPath: url, fullPath: url, exception: error);
      }
    }
    return new Map();
  }

  Future<Map<String, dynamic>> sendPostRequest(
      {String? url,
      Map<String, String>? headers,
      dynamic body,
      String? apiName}) async {
    //print("HEREE1");
    var data = body != null ? json.encode(body) : null;
    try {
      //print(url);
      var response =
          await http.post(Uri.parse(url ?? ""), headers: headers, body: data);

      ////print(response.body);
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> m = new Map();
        m.putIfAbsent("state", () => true);
        m.putIfAbsent("StatusCode", () => response.statusCode);
        m.putIfAbsent("path", () => url);
        m.putIfAbsent('data', () => response.body.toString());
        m.putIfAbsent("RelativePath", () => url);
        return m;
      } else {
        //print("heret");
        Map<String, dynamic> m = new Map();
        m.putIfAbsent("state", () => false);
        m.putIfAbsent("StatusCode", () => response.statusCode);
        m.putIfAbsent("path", () => url);
        m.putIfAbsent("RelativePath", () => url);
        m.putIfAbsent(
            'data',
            () => (response != null && response.body != null)
                ? response.body.toString()
                : null);

        try {
          Helpers.sendLog(
              url: url,
              data: body.toString(),
              errorMsg: (response != null && response.body != null)
                  ? response.body.toString()
                  : "");
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        return m;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error != null) {
        try {
          Helpers.sendLog(
              url: url, data: body.toString(), errorMsg: error.toString());
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw APIException(apiPath: url, fullPath: url, exception: error);
      }
    }

    return new Map();
  }
}
