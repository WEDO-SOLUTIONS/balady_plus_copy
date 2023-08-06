import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show translator;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../features/_shared_feature_/shared_feature_exports.dart'
    show AuthData, AuthDataModel;
import '../../errors/errors_exports.dart'
    show
        BadRequestException,
        ConflictException,
        DeadlineExceededException,
        FailedToGenerateTokenException,
        InternalServerErrorException,
        MethodNotAllowedException,
        NoDataFoundException,
        NoInternetConnectionException,
        RequestNotFoundException,
        TokenHasExpiredException,
        TokenNotFoundException,
        UnAuthorizedException;
import '../../utils/utils_exports.dart'
    show
        ApiHeader,
        ApiPOST,
        ApiParam,
        CommonFunctions,
        CommonProperties,
        EnvType,
        Log,
        WithDelay;
import '../services_exports.dart' show NavigationService, NetworkConnection;

// Please using any technique to create singleton WebService (GetIt)
class WebServiceWeather {
  final Dio dio;

  WebServiceWeather({required this.dio}) {
    dio.options.baseUrl = "https://api.weatherapi.com";
    dio.options.connectTimeout = const Duration(milliseconds: 60000);
    dio.options.receiveTimeout = const Duration(milliseconds: 60000);
    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    dio.options.headers = {};
    dio.interceptors.add(AppInterceptors());
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
    ));
  }
  WebServiceWeather.newDio({
    required this.dio,
  });
}

class AppInterceptors extends Interceptor {
  late NetworkConnection networkConnection;

  AppInterceptors() {
    networkConnection = sl<NetworkConnection>();
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    "On-Sending-Request ${options.uri}".actionLog();
    // Update language
    options.headers[ApiHeader.language.eName] = languageCode;

    if (await networkConnection.isConnected == false) {
      "Request-Rejected because 'Network-Disconnected'".errorLog();
      return handler.reject(NoInternetConnectionException(options));
    }

    String url = options.uri.toString();
    options.headers.putIfAbsent("x-channel-id", () => "MOBILE");
    //if (options.headers['Authorization'] == null) {
    print(options.headers);
    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    "Opps, recieved Error: ${err.response?.statusCode}".errorLog();
    "Opps, recieved Error: ${err.response?.data}".errorLog();
    print(err);

    print(err.error);
    print(err.type);

    switch (err.type) {
      case DioErrorType.connectionTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioErrorType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            if (err.response?.data['data']['responseCode'] == '2') {
              throw NoDataFoundException(err.requestOptions, err.response);
            }
            throw BadRequestException(err.requestOptions, err.response);
          case 401:
            throw UnAuthorizedException(err.requestOptions, err.response);
          case 404:
            throw RequestNotFoundException(err.requestOptions, err.response);
          case 405:
            throw MethodNotAllowedException(err.requestOptions, err.response);
          case 409:
            throw ConflictException(err.requestOptions, err.response);
          case 500:
            throw InternalServerErrorException(
              err.requestOptions,
              err.response,
            );
          default:
            throw BadRequestException(err.requestOptions, err.response);
        }
        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.badCertificate:
        break;
      case DioErrorType.connectionError:
        throw NoInternetConnectionException(err.requestOptions);
        break;
      case DioErrorType.unknown:
        throw BadRequestException(err.requestOptions, err.response);

      default:
        throw BadRequestException(err.requestOptions, err.response);
    }
    throw BadRequestException(err.requestOptions, err.response);

    return handler.next(err);
  }

  String get languageCode => translator.activeLanguageCode;
  bool get mounted => true;
}
