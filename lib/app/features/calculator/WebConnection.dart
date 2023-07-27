import 'dart:convert';
import 'dart:io';
import 'package:balady_plus/app/features/calculator/presentation/pages/presenter/ServiceCalculatorPresenter.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/constants/remote_config.dart';

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
      print(url);
      final response = await http.get(Uri.parse(url ?? ""), headers: headers);
      // print(response.body);
      if (response.statusCode == HttpStatus.ok ||
          (response.statusCode == HttpStatus.accepted)) {
        //print("OKKK");
        Map<String, dynamic> m = new Map();
        m.putIfAbsent("state", () => true);
        m.putIfAbsent("StatusCode", () => response.statusCode);
        m.putIfAbsent("path", () => url);
        m.putIfAbsent('data', () => response.body.toString());
        m.putIfAbsent("RelativePath", () => url);
        //print("OOOO");
        //print(m);
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
        return m;
      }
    } catch (error) {
      print(error);
      if (error != null)
        throw APIException(apiPath: url, fullPath: url, exception: error);
    }
    return new Map();
  }

  Future<Map<String, dynamic>> sendPostRequest(
      {String? url,
      Map<String, String>? headers,
      dynamic body,
      String? apiName}) async {
    var data = body != null ? json.encode(body) : null;
    try {
      print(url);
      var response =
          await http.post(Uri.parse(url ?? ""), headers: headers, body: data);

      //print(response.body);
      if (response.statusCode == HttpStatus.ok) {
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

        return m;
      }
    } catch (error) {
      if (error != null)
        throw APIException(apiPath: url, fullPath: url, exception: error);
    }

    return new Map();
  }
}
