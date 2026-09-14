import 'dart:convert';
import 'dart:io';

import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation, translator;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../../core/dependency_injection/dependency_injection_exports.dart' show sl;
import '../../../events_logs/balady_logs.dart';
import '../../../features/entry_point/presentation/cubit/auth_cubit.dart';
import '../../errors/errors_exports.dart'
    show
        BadRequestException,
        ConflictException,
        DeadlineExceededException,
        InternalServerErrorException,
        MethodNotAllowedException,
        NoDataFoundException,
        NoInternetConnectionException,
        RequestNotFoundException;
import '../../utils/utils_exports.dart' show ApiHeader, CommonFunctions, CommonProperties, EnvType, Log;
import '../services_exports.dart' show NetworkConnection;

// Please using any technique to create singleton WebService (GetIt)
class WebService {
  final Dio dio;

  WebService({required this.dio}) {
    dio.options.baseUrl = sl<EnvType>().domain;
    dio.options.connectTimeout = const Duration(milliseconds: 60000);
    dio.options.receiveTimeout = const Duration(milliseconds: 60000);
    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    dio.options.headers = {};
    // dio.addSentry();

    if (!kReleaseMode) {
      dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    }

    dio.interceptors.add(PrettyDioLogger(requestHeader: false, requestBody: false, responseBody: false));

    dio.interceptors.add(AppInterceptors());
    dio.interceptors.add(
      AppCertificatePinningInterceptor(
        allowedSHAFingerprints: CommonProperties.allowedSHAFingerprints,
        callFollowingErrorInterceptor: true,
      ),
    );
  }

  WebService.newDio({required this.dio});
}

class AppCertificatePinningInterceptor extends Interceptor {
  final List<String> _allowedSHAFingerprints;
  final int _timeout;
  final bool callFollowingErrorInterceptor;
  Future<String>? secure = Future.value('');

  AppCertificatePinningInterceptor({
    List<String>? allowedSHAFingerprints,
    int timeout = 0,
    this.callFollowingErrorInterceptor = false,
  }) : _allowedSHAFingerprints = allowedSHAFingerprints ?? <String>[],
       _timeout = timeout;

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // iOS bug: Alamofire is failing to return parallel requests for certificate validation
      if (Platform.isIOS && secure != null) {
        await secure;
      }

      if (options.uri.toString().toLowerCase().contains(sl<EnvType>().domain) == true) {
        var baseUrl = options.baseUrl;

        if (options.path.contains('http') || options.baseUrl.isEmpty) {
          baseUrl = options.path;
        }

        secure = HttpCertificatePinning.check(
          serverURL: baseUrl,
          headerHttp: {},
          sha: SHA.SHA256,
          allowedSHAFingerprints: _allowedSHAFingerprints,
          timeout: _timeout,
        );
        final secureString = await secure ?? '';
        secure?.whenComplete(() => secure = null);

        if (secureString.contains('CONNECTION_SECURE')) {
          return super.onRequest(options, handler);
        } else {
          handler.reject(
            DioException(
              requestOptions: options,
              error: const CertificateNotVerifiedException(),
              type: DioExceptionType.badCertificate,
            ),
            callFollowingErrorInterceptor,
          );
        }
      } else {
        return super.onRequest(options, handler);
      }
    } on Exception catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      dynamic error2;

      if (error is PlatformException && error.code == 'CONNECTION_NOT_SECURE') {
        error2 = const CertificateNotVerifiedException();
      } else {
        error2 = CertificateCouldNotBeVerifiedException(error);
      }

      handler.reject(
        DioException(requestOptions: options, error: error2, type: DioExceptionType.badCertificate),
        callFollowingErrorInterceptor,
      );
    }
  }
}

class AppInterceptors extends Interceptor {
  late NetworkConnection networkConnection;

  AppInterceptors() {
    networkConnection = sl<NetworkConnection>();
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    "On-Sending-Request ${options.uri}".actionLog();

    options.headers[ApiHeader.language.eName] = languageCode;
    options.headers["Accept-Language"] = languageCode;

    String? xCorrelationId;

    if (options.uri.toString().toLowerCase().contains("validate-license") ||
        options.uri.toString().toLowerCase().contains("license/permits") ||
        options.uri.toString().toLowerCase().contains("send-to-new-owner") ||
        options.uri.toString().toLowerCase().contains("selected/permits") ||
        options.uri.toString().toLowerCase().contains("selected-permits/by-new-owner") ||
        options.uri.toString().toLowerCase().contains("transfer/shop-info") ||
        options.uri.toString().toLowerCase().contains("transfer/shop-ownership-info") ||
        options.uri.toString().toLowerCase().contains("transfer/attachments") ||
        options.uri.toString().toLowerCase().contains("submit/by-new-owner") ||
        options.uri.toString().toLowerCase().contains("accept/by-new-owner") ||
        options.uri.toString().toLowerCase().contains("reject/by-new-owner") ||
        options.uri.toString().toLowerCase().contains("transfer/upload-attachment")) {
      // options.headers.putIfAbsent(ApiHeaders.xSubmitterRelation, () => CommonProperties.selectedDelegator?.getRole() ?? "HIMSELF");
    }
    if (await networkConnection.isConnected == false) {
      "Request-Rejected because 'Network-Disconnected'".errorLog();
      return handler.reject(NoInternetConnectionException(options));
    }

    String url = options.uri.toString();
    final method = options.method;

    if (options.headers['Authorization'] == null &&
        CommonProperties.isLoggedInMunicipality &&
        !options.uri.toString().contains("bcg/upload-file")) {
      options.headers['Authorization'] = 'Bearer ${CommonProperties.token}';
    }

    if (url.contains("damaged-vehicle-mobile/car-models")) {
      url = options.baseUrl + options.path;
      url += "?CompanyID=${options.queryParameters["CompanyID"]}";
    }
    if (options.headers[ApiHeader.requiresToken.eName] == false) {
      options.headers.remove("Authorization");
    }
    if (options.data is! FormData) {
      final verifyingKEY = CommonFunctions.hashRequest(
        Uri.decodeQueryComponent(url),
        method,
        body: (options.data != null && !options.uri.toString().contains("bcg/upload-file"))
            ? json.encode(options.data)
            : null,
        authorization: !options.uri.toString().contains("bcg/upload-file")
            ? options.headers.containsKey("Authorization")
            : false,
        corelationId: xCorrelationId,
      );

      debugPrint(verifyingKEY.toString());

      options.headers.putIfAbsent(ApiHeader.verifyingKEY.name, () => verifyingKEY);
    }
    options.headers.putIfAbsent("x-channel-id", () => "MOBILE");

    options.headers.removeWhere((key, value) => key == "requiresToken");
    //if (options.headers['Authorization'] == null) {

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    "Opps, recieved Error: ${err.response?.statusCode}".errorLog();
    "Opps, recieved Error: ${err.response?.data}".errorLog();
    _logDioError(err);
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            if (err.response?.data['data']['responseCode'] == '2') {
              throw NoDataFoundException(err.requestOptions, err.response);
            }
            throw BadRequestException(err.requestOptions, err.response);

          case 202:
            throw BadRequestException(err.requestOptions, err.response);
          case 401:
            if (err.requestOptions.uri.path.contains(ApiUrl.weatherAlerts)) {
              break;
            }
            final refreshToken = sl<EntryPointCubit>().state.token?.refreshToken;
            if (refreshToken != null) {
              sl<EntryPointCubit>().refreshToken(refreshToken);
            }
          // throw UnAuthorizedException(err.requestOptions, err.response);
          case 404:
            throw RequestNotFoundException(err.requestOptions, err.response);
          case 405:
            throw MethodNotAllowedException(err.requestOptions, err.response);
          case 409:
            throw ConflictException(err.requestOptions, err.response);
          case 500:
            throw InternalServerErrorException(err.requestOptions, err.response);
          default:
            throw BadRequestException(err.requestOptions, err.response);
        }
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.badCertificate:
        CommonFunctions.showError("badCerifcation".tr());

        throw BadRequestException(err.requestOptions, err.response);

      case DioExceptionType.connectionError:
        throw NoInternetConnectionException(err.requestOptions);

      case DioExceptionType.unknown:
        throw BadRequestException(err.requestOptions, err.response);

      default:
        throw BadRequestException(err.requestOptions, err.response);
    }
    throw BadRequestException(err.requestOptions, err.response);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: 'Request Successful',
          data: {
            "url": response.requestOptions.baseUrl + response.requestOptions.path,
            "queryParameters": response.requestOptions.queryParameters,
            "requestBody": response.requestOptions.data,
            "headers": response.requestOptions.headers,
            "method": response.requestOptions.method,
            "responseData": response.data,
            "statusCode": response.statusCode,
          },
        ),
      );
    }
    return handler.next(response);
  }

  String get languageCode => translator.activeLanguageCode;

  bool get mounted => true;
}

// need Add next Headers
/*
x-fe-client-ip
"x-platform-id": "balady",
"x-channel-id": "mobile",

 */
class ApiHeaders {
  static const authorization = "authorization";

  static const xFeappId = "x-fe-app-id";
  static const xFeAppVersion = "x-fe-app-version";
  static const xFeDeviceId = "x-fe-device-id";
  static const xFeDeviceOs = "x-fe-device-os";
  static const xSessionId = "x-session-id";
  static const xUserProfileId = "x-user-profile-id";
  static const xCorrelationId = "x-correlation-id";
  static const xSubmitterRelation = "x-submitter-relation";
}

void _logDioError(DioException err) async {
  Contexts contexts = Contexts()
    ..['Request-Data'] = {
      "url": err.requestOptions.baseUrl + err.requestOptions.path,
      "queryParameters": err.requestOptions.queryParameters,
      "requestBody": err.requestOptions.data,
      "headers": err.requestOptions.headers,
      "method": err.requestOptions.method,
    };
  contexts['Response'] = {
    if (err.response != null) ...{"responseData": err.response?.data, "statusCode": err.response?.statusCode},
  };
  Sentry.captureEvent(
    SentryEvent(throwable: err, contexts: contexts),
    stackTrace: err.stackTrace,
  );
}

// void sendAPIEvents({
//   required String nameEvent,
//   required String responseData,
//   required RequestOptions requestOptions,
//   int? statusCode,
// }) {
//   try {
//     String requestData = requestOptions.data?.toString() ?? "";
//     LogsViewModel().sendEventFromModel(
//       event: RequestApiModel(
//         nameEvent: nameEvent,
//         message: responseData.length > 1024
//             ? responseData.substring(0, 1024)
//             : responseData,
//         url: requestOptions.baseUrl + requestOptions.path,
//         body: requestData.length > 1024
//             ? requestData.substring(0, 1024)
//             : requestData,
//         verifyingKEY: requestOptions.headers["verifyingKEY"] ?? "",
//         statusCode: statusCode,
//       ),
//     );
//   } catch (error, stackTrace) {
//     LogsViewModel().sendEventFromModel(
//       event: ErrorExceptionModel(
//         nameEvent: EventsName.handledException,
//         message: error.toString(),
//         stackTrace: stackTrace.toString(),
//       ),
//     );
//   }
// }
