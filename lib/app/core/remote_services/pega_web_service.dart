import 'dart:convert';
import 'dart:io';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:localize_and_translate/localize_and_translate.dart';

import '../dependency_injection/injection_container.dart';
import '../services/local/helpers.dart';
import '../utils/common_functions.dart';
import '../utils/constants/remote_config.dart';
import 'package:flutter/foundation.dart';

class PegaWebService {
  static String baseURL = RemoteConfig.apigeeURL;
  // static String pegaBaseURL = RemoteConfig.pegaURL;

  Future<Map<String, dynamic>> getNewApigeeRequest(
    String url, {
    String? relativePath,
    Map<String, dynamic>? queryParams,
    Map<String, String>? extraHeadersParams,
    bool autoLogout = true,
  }) async {
    String queryString = "";
    if (relativePath != null) {
      queryString = relativePath;
    }
    if (queryParams != null) {
      queryString = "?${Uri(queryParameters: queryParams).query}";
    }

    var requestUrl = baseURL + url + queryString;
    debugPrint("url: $requestUrl");
    Map<String, dynamic> result = {};
    try {
      var headers = {
        'Authorization': 'Bearer ${CommonProperties.token}',
        "x-channel-id": "MOBILE",
        "lang": translator.activeLanguageCode,
        "Accept-Language": translator.activeLanguageCode,
      };

      if (extraHeadersParams != null) headers.addAll(extraHeadersParams);

      var response = await http.get(Uri.parse(requestUrl), headers: headers);
      debugPrint("url response: ${utf8.decode(response.bodyBytes)}");
      if (response.statusCode == HttpStatus.ok) {
        result.putIfAbsent("state", () => true);
        result.putIfAbsent("data", () => utf8.decode(response.bodyBytes).toString());
      } else if (response.statusCode == HttpStatus.unauthorized) {
        result.putIfAbsent("state", () => false);
        result.putIfAbsent("data", () => utf8.decode(response.bodyBytes).toString());
        if (autoLogout) {
          result.putIfAbsent("error", () => ('session_ended_error').tr());
        } else {
          result.putIfAbsent("error", () => ('errors_server_error_1').tr());
        }

        try {
          Helpers.sendLog(
            url: baseURL + url,
            qeuryParms: queryString,
            data: utf8.decode(response.bodyBytes).toString(),
            statusCode: response.statusCode,
          );
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
        if (autoLogout) sl<EntryPointCubit>().autoLogout();
      } else {
        result.putIfAbsent("state", () => false);
        result.putIfAbsent("data", () => utf8.decode(response.bodyBytes).toString());
        result.putIfAbsent("error", () => ('errors_server_error_1').tr());

        try {
          Helpers.sendLog(
            url: baseURL + url,
            qeuryParms: queryString,
            data: response.body,
            statusCode: response.statusCode,
          );
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      result.putIfAbsent("state", () => false);
      result.putIfAbsent("error", () => ('errors_server_error_2').tr());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        result["error"] = ('errors_internet_error_1').tr();
      }

      try {
        Helpers.sendLog(url: baseURL + url, qeuryParms: queryString, data: error.toString(), statusCode: 0);
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
    }
    return result;
  }

  // Future<Map<String, dynamic>> getApigeeRequest1(String url,
  //     {String? relativePath,
  //     Map<String, dynamic>? queryParams,
  //     Map<String, String>? extraHeadersParams,
  //     bool autoLogout = true}) async {
  //   String queryString = "";
  //   if (relativePath != null) {
  //     queryString = relativePath;
  //   }
  //   if (queryParams != null) {
  //     queryString = "?" + Uri(queryParameters: queryParams).query;
  //   }
  //
  //   var requestUrl = baseURL + url + queryString;
  //   ////print("url: " + requestUrl);
  //   Map<String, dynamic> result = {};
  //   try {
  //     var headers = {
  //       'Authorization': 'Bearer ${CommonProperties.token}',
  //       "x-channel-id": "MOBILE",
  //       "lang": translator.activeLanguageCode,
  //       "Accept-Language": translator.activeLanguageCode,
  //     };
  //
  //     if (extraHeadersParams != null) headers.addAll(extraHeadersParams);
  //
  //     var response = await http.get(
  //       Uri.parse(requestUrl),
  //       headers: headers,
  //     );
  //     print("url response: " + utf8.decode(response.bodyBytes).toString());
  //     if (response.statusCode == HttpStatus.ok) {
  //       result.putIfAbsent("state", () => true);
  //       result.putIfAbsent(
  //           "data", () => utf8.decode(response.bodyBytes).toString());
  //     } else if (response.statusCode == HttpStatus.unauthorized) {
  //       result.putIfAbsent("state", () => false);
  //       result.putIfAbsent(
  //           "data", () => utf8.decode(response.bodyBytes).toString());
  //       if (autoLogout)
  //         result.putIfAbsent("error", () => ('session_ended_error').tr());
  //       else
  //         result.putIfAbsent("error", () => ('errors_server_error_1').tr());
  //
  //       try {
  //         Helpers.sendLog(
  //             url: baseURL + url,
  //             qeuryParms: queryString,
  //             data: utf8.decode(response.bodyBytes).toString(),
  //             statusCode: response.statusCode);
  //       } catch (error, stackTrace) {
  //         LogsViewModel().sendEventFromModel(
  //           event: ErrorExceptionModel(
  //             nameEvent: EventsName.handledException,
  //             message: error.toString(),
  //             stackTrace: stackTrace.toString(),
  //           ),
  //         );
  //       }
  //       if (autoLogout) sl<EntryPointCubit>().autoLogout();
  //     } else {
  //       result.putIfAbsent("state", () => false);
  //       result.putIfAbsent(
  //           "data", () => utf8.decode(response.bodyBytes).toString());
  //       result.putIfAbsent("error", () => ('errors_server_error_1').tr());
  //
  //       try {
  //         Helpers.sendLog(
  //             url: baseURL + url,
  //             qeuryParms: queryString,
  //             data: response.body,
  //             statusCode: response.statusCode);
  //       } catch (error, stackTrace) {
  //         LogsViewModel().sendEventFromModel(
  //           event: ErrorExceptionModel(
  //             nameEvent: EventsName.handledException,
  //             message: error.toString(),
  //             stackTrace: stackTrace.toString(),
  //           ),
  //         );
  //       }
  //     }
  //   } catch (error, stackTrace) {
  //     LogsViewModel().sendEventFromModel(
  //       event: ErrorExceptionModel(
  //         nameEvent: EventsName.handledException,
  //         message: error.toString(),
  //         stackTrace: stackTrace.toString(),
  //       ),
  //     );
  //     result.putIfAbsent("state", () => false);
  //     result.putIfAbsent("error", () => ('errors_server_error_2').tr());
  //     var connectivityResult = await (Connectivity().checkConnectivity());
  //     if (connectivityResult == ConnectivityResult.none) {
  //       result["error"] = ('errors_internet_error_1').tr();
  //     }
  //
  //     try {
  //       Helpers.sendLog(
  //           url: baseURL + url,
  //           qeuryParms: queryString,
  //           data: error.toString(),
  //           statusCode: 0);
  //     } catch (error, stackTrace) {
  //       LogsViewModel().sendEventFromModel(
  //         event: ErrorExceptionModel(
  //           nameEvent: EventsName.handledException,
  //           message: error.toString(),
  //           stackTrace: stackTrace.toString(),
  //         ),
  //       );
  //     }
  //   }
  //   return result;
  // }

  Future<Map<String, dynamic>> getApigeeRequest(
    String url, {
    String? relativePath,
    Map<String, dynamic>? queryParams,
    Map<String, String>? extraHeadersParams,
    int? timeLimit,
    bool autoLogout = true,
  }) async {
    bool isSuccess = await sl<EntryPointCubit>().refreshAPIGeeToken();
    String queryString = "";
    if (relativePath != null) {
      queryString = relativePath;
    }

    if (queryParams != null) {
      queryString = "?${Uri(queryParameters: queryParams).query}";
    }

    var requestUrl = baseURL + url + queryString;
    debugPrint("url: $requestUrl");
    Map<String, dynamic> result = {};
    if (isSuccess) {
      try {
        String loginIdentityId = CommonProperties.userInfo?.idNo ?? "";
        String loginIdentityType = CommonProperties.userInfo?.getIdType() ?? "";

        String verifyingKEY = hashRequest(
          requestUrl,
          "GET",
          loginIdentityId: loginIdentityId,
          loginIdentityType: loginIdentityType,
        );

        var headers = {
          'Authorization': 'Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}',
          "loginIdentityId": loginIdentityId,
          "loginIdentityType": loginIdentityType,
          'Cookie': sl<EntryPointCubit>().state.token?.appCookie ?? "",
          "Content-Type": "application/json",
          "verifyingKEY": verifyingKEY,
          "SSOToken": CommonProperties.token,
          "x-channel-id": "MOBILE",
          "lang": translator.activeLanguageCode,
          "Accept-Language": translator.activeLanguageCode,
        };

        debugPrint(headers.toString());
        if (extraHeadersParams != null) headers.addAll(extraHeadersParams);

        var response = await http
            .get(Uri.parse(requestUrl), headers: headers)
            .timeout(Duration(seconds: timeLimit ?? 5));
        debugPrint("url response: ${utf8.decode(response.bodyBytes)}");
        if (response.statusCode == HttpStatus.ok) {
          result.putIfAbsent("state", () => true);
          result.putIfAbsent("data", () => utf8.decode(response.bodyBytes).toString());
        } else if (response.statusCode == HttpStatus.unauthorized) {
          result.putIfAbsent("state", () => false);
          result.putIfAbsent("data", () => utf8.decode(response.bodyBytes).toString());
          if (autoLogout) {
            result.putIfAbsent("error", () => ('session_ended_error').tr());
          } else {
            result.putIfAbsent("error", () => ('errors_server_error_1').tr());
          }

          try {
            Helpers.sendLog(
              url: baseURL + url,
              qeuryParms: queryString,
              data: utf8.decode(response.bodyBytes).toString(),
              statusCode: response.statusCode,
            );
          } catch (error, stackTrace) {
            LogsViewModel().sendEventFromModel(
              event: ErrorExceptionModel(
                nameEvent: EventsName.handledException,
                message: error.toString(),
                stackTrace: stackTrace.toString(),
              ),
            );
          }
          if (autoLogout) sl<EntryPointCubit>().autoLogout();
        } else {
          result.putIfAbsent("state", () => false);
          result.putIfAbsent("data", () => utf8.decode(response.bodyBytes).toString());
          result.putIfAbsent("error", () => ('errors_server_error_1').tr());

          try {
            Helpers.sendLog(
              url: baseURL + url,
              qeuryParms: queryString,
              data: response.body,
              statusCode: response.statusCode,
            );
          } catch (error, stackTrace) {
            LogsViewModel().sendEventFromModel(
              event: ErrorExceptionModel(
                nameEvent: EventsName.handledException,
                message: error.toString(),
                stackTrace: stackTrace.toString(),
              ),
            );
          }
        }
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
        result.putIfAbsent("state", () => false);
        result.putIfAbsent("error", () => ('errors_server_error_2').tr());
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          result["error"] = ('errors_internet_error_1').tr();
        }

        try {
          Helpers.sendLog(url: baseURL + url, qeuryParms: queryString, data: error.toString(), statusCode: 0);
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
      }
      return result;
    } else {
      try {
        Helpers.sendLog(url: baseURL + url, qeuryParms: queryString, statusCode: 1);
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }

      result.putIfAbsent("state", () => false);
      result.putIfAbsent("error", () => ('errors_server_error_2').tr());

      return result;
    }
  }

  Future<Map<String, dynamic>> postApigeeRequest(
    String url, {
    String? relativePath,
    Map<String, dynamic>? queryParams,
    Map<String, String>? extraHeadersParams,
    dynamic body,
  }) async {
    bool isSuccess = await sl<EntryPointCubit>().refreshAPIGeeToken();

    String queryString = "";
    var data = body != null ? json.encode(body) : null;
    debugPrint(data.toString());
    if (relativePath != null) {
      queryString = relativePath;
    }
    if (queryParams != null) {
      queryString = "?${Uri.decodeQueryComponent(Uri(queryParameters: queryParams).query)}";
    }
    var requestUrl = baseURL + url + queryString;
    debugPrint(requestUrl.toString());
    Map<String, dynamic> result = {};
    try {
      String loginIdentityId = CommonProperties.userInfo?.idNo ?? "";
      String loginIdentityType = CommonProperties.userInfo?.getIdType() ?? "";

      String verifyingKEY = hashRequest(
        requestUrl,
        "POST",
        body: data,
        loginIdentityId: loginIdentityId,
        loginIdentityType: loginIdentityType,
      );

      var headers = {
        'Authorization': 'Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}',
        "loginIdentityId": loginIdentityId,
        "loginIdentityType": loginIdentityType,
        'Cookie': sl<EntryPointCubit>().state.token?.appCookie ?? "",
        "Content-Type": "application/json",
        "verifyingKEY": verifyingKEY,
        "SSOToken": CommonProperties.token,
        "x-channel-id": "MOBILE",
        "lang": translator.activeLanguageCode,
        "Accept-Language": translator.activeLanguageCode,
      };

      if (extraHeadersParams != null) headers.addAll(extraHeadersParams);
      var response = await http.post(Uri.parse(requestUrl), body: data, headers: headers);
      debugPrint((utf8.decode(response.bodyBytes).toString()).toString());
      if (response.statusCode == HttpStatus.ok) {
        result.putIfAbsent("state", () => true);
        result.putIfAbsent("data", () => utf8.decode(response.bodyBytes).toString());
      } else if (response.statusCode == HttpStatus.unauthorized) {
        result.putIfAbsent("state", () => false);
        result.putIfAbsent("data", () => utf8.decode(response.bodyBytes).toString());
        result.putIfAbsent("error", () => ('errors_server_error_1').tr());

        try {
          Helpers.sendLog(
            url: baseURL + url,
            qeuryParms: queryString,
            data: utf8.decode(response.bodyBytes).toString(),
            statusCode: response.statusCode,
          );
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }

        //  locator<AuthService>().autoLogout();
      } else {
        result.putIfAbsent("state", () => false);
        result.putIfAbsent("data", () => utf8.decode(response.bodyBytes).toString());
        result.putIfAbsent("error", () => ('errors_server_error_1').tr());

        try {
          Helpers.sendLog(
            url: baseURL + url,
            qeuryParms: queryString,
            data: utf8.decode(response.bodyBytes).toString(),
            body: data,
            statusCode: response.statusCode,
          );
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      result.putIfAbsent("state", () => false);
      result.putIfAbsent("error", () => ('errors_server_error_2').tr());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        result["error"] = ('errors_internet_error_1').tr();
      }

      try {
        Helpers.sendLog(url: baseURL + url, qeuryParms: queryString, data: error.toString(), statusCode: 0);
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
    }

    return result;
  }

  String hashRequest(String url, String method, {String? body, String? loginIdentityId, String? loginIdentityType}) {
    //var encodedURL = Uri.encodeComponent(url);
    String message = "";
    message = '$url${method}Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}';
    if (body != null) {
      message += body.replaceAll(RegExp(r'^/\\n/g'), "");
    }

    if (loginIdentityId != null) message += loginIdentityId;

    if (loginIdentityType != null) message += loginIdentityType;

    message.trim();
    var key = utf8.encode(RemoteConfig.hmCode);
    var bytes = utf8.encode(message);

    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);
    String base64 = base64Encode(digest.bytes);
    return base64;
  }

  Future<Map<String, dynamic>> uploadApigeeFile(
    String url, {
    String? relativePath,
    Map<String, dynamic>? queryParams,
    Uint8List? base64,
    String? fileName,
    String? mimeType,
    dynamic body,
  }) async {
    bool isSuccess = await sl<EntryPointCubit>().refreshAPIGeeToken();

    String queryString = "";
    var data = body != null ? json.encode(body) : null;

    if (relativePath != null) {
      queryString = relativePath;
    }
    if (queryParams != null) {
      queryString = "?${Uri.decodeQueryComponent(Uri(queryParameters: queryParams).query)}";
    }
    var requestUrl = baseURL + url + queryString;

    Map<String, dynamic> result = {};
    try {
      var request = http.MultipartRequest('POST', Uri.parse(requestUrl));

      String loginIdentityId = CommonProperties.userInfo?.idNo ?? "";
      String loginIdentityType = CommonProperties.userInfo?.getIdType() ?? "";

      String verifyingKEY = hashRequest(
        requestUrl,
        "POST",
        body: data,
        loginIdentityId: loginIdentityId,
        loginIdentityType: loginIdentityType,
      );

      request.headers['fileContentType'] = mimeType ?? "";
      request.headers['authorization'] = 'Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}';
      request.headers['loginIdentityId'] = loginIdentityId;
      request.headers['loginIdentityType'] = loginIdentityType;
      request.headers['verifyingKEY'] = verifyingKEY;
      request.headers['SSOToken'] = CommonProperties.token;
      request.headers['x-channel-id'] = "MOBILE";

      http.MultipartFile file = http.MultipartFile.fromBytes('file', base64!.toList(), filename: fileName);

      request.files.add(file);
      var response = await request.send();

      final respStr = await response.stream.bytesToString();
      if (response.statusCode == HttpStatus.ok) {
        result.putIfAbsent("state", () => true);
        result.putIfAbsent("data", () => respStr);
      } else {
        result.putIfAbsent("state", () => false);
        result.putIfAbsent("data", () => respStr);
        result.putIfAbsent("error", () => ('errors_server_error_1').tr());

        try {
          Helpers.sendLog(
            url: baseURL + url,
            qeuryParms: queryString,
            data: respStr,
            body: data,
            statusCode: response.statusCode,
          );
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      result.putIfAbsent("state", () => false);
      result.putIfAbsent("error", () => ('errors_server_error_2').tr());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        result["error"] = ('errors_internet_error_1').tr();
      }

      try {
        Helpers.sendLog(url: baseURL + url, qeuryParms: queryString, data: error.toString(), body: data, statusCode: 0);
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
    }

    return result;
  }

  Future<Map<String, dynamic>> getApigeeRequestWithoutUTF(
    String url, {
    String? relativePath,
    Map<String, dynamic>? queryParams,
  }) async {
    bool isSuccess = await sl<EntryPointCubit>().refreshAPIGeeToken();

    String queryString = "";
    if (relativePath != null) {
      queryString = relativePath;
    }
    if (queryParams != null) {
      queryString = "?${Uri(queryParameters: queryParams).query}";
    }

    var requestUrl = baseURL + url + queryString;
    //print("url: " + requestUrl);
    Map<String, dynamic> result = {};
    try {
      String loginIdentityId = CommonProperties.userInfo?.idNo ?? "";
      String loginIdentityType = CommonProperties.userInfo?.getIdType() ?? "";

      String verifyingKEY = hashRequest(
        requestUrl,
        "GET",
        loginIdentityId: loginIdentityId,
        loginIdentityType: loginIdentityType,
      );

      var response = await http.get(
        Uri.parse(requestUrl),
        headers: {
          'Authorization': 'Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}',
          "loginIdentityId": loginIdentityId,
          "loginIdentityType": loginIdentityType,
          'Cookie': sl<EntryPointCubit>().state.token?.appCookie ?? "",
          "Content-Type": "application/json",
          "verifyingKEY": verifyingKEY,
          "SSOToken": CommonProperties.token,
          "x-channel-id": "MOBILE",
          "lang": translator.activeLanguageCode,
        },
      );
      //print("response: " + response.headers.toString());
      //print(response.statusCode);
      if (response.statusCode == HttpStatus.ok) {
        result.putIfAbsent("state", () => true);
        result.putIfAbsent("data", () => response.bodyBytes);
        result.putIfAbsent("Content-Type", () => response.headers["content-type"]);
      } else {
        result.putIfAbsent("state", () => false);
        result.putIfAbsent("data", () => response.bodyBytes);
        result.putIfAbsent("error", () => ('errors_server_error_1').tr());

        try {
          Helpers.sendLog(
            url: baseURL + url,
            qeuryParms: queryString,
            data: response.body.toString(),
            statusCode: response.statusCode,
          );
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      //print("exception: " + error.toString());
      result.putIfAbsent("state", () => false);
      result.putIfAbsent("error", () => ('errors_server_error_2').tr());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        result["error"] = ('errors_internet_error_1').tr();
      }

      try {
        Helpers.sendLog(url: baseURL + url, qeuryParms: queryString, data: error.toString(), statusCode: 0);
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
    }
    return result;
  }

  Future<Map<String, dynamic>> getNewApigeeRequestWithoutUTF(
    String url, {
    String? relativePath,
    Map<String, dynamic>? queryParams,
    Map<String, String>? extraHeadersParams,
  }) async {
    String queryString = "";
    if (relativePath != null) {
      queryString = relativePath;
    }
    if (queryParams != null) {
      queryString = "?${Uri(queryParameters: queryParams).query}";
    }

    var requestUrl = baseURL + url + queryString;
    //print("url: " + requestUrl);
    Map<String, dynamic> result = {};
    try {
      var headers = {
        'Authorization': 'Bearer ${CommonProperties.token}',
        "x-channel-id": "MOBILE",
        "lang": translator.activeLanguageCode,
      };

      if (extraHeadersParams != null) headers.addAll(extraHeadersParams);

      var response = await http.get(Uri.parse(requestUrl), headers: headers);
      //print("response: " + response.body);
      //print(response.statusCode);
      if (response.statusCode == HttpStatus.ok) {
        result.putIfAbsent("state", () => true);
        result.putIfAbsent("data", () => response.bodyBytes);
        result.putIfAbsent("Content-Type", () => response.headers["content-type"]);
      } else {
        result.putIfAbsent("state", () => false);
        result.putIfAbsent("data", () => response.bodyBytes);
        result.putIfAbsent("error", () => ('errors_server_error_1').tr());

        try {
          Helpers.sendLog(
            url: baseURL + url,
            qeuryParms: queryString,
            data: response.body.toString(),
            statusCode: response.statusCode,
          );
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      //print("exception: " + error.toString());
      result.putIfAbsent("state", () => false);
      result.putIfAbsent("error", () => ('errors_server_error_2').tr());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        result["error"] = ('errors_internet_error_1').tr();
      }

      try {
        Helpers.sendLog(url: baseURL + url, qeuryParms: queryString, data: error.toString(), statusCode: 0);
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
    }
    return result;
  }
}
