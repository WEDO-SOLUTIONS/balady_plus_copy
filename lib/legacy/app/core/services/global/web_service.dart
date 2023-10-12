import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show translator;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
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
class WebService {
  final Dio dio;

  WebService({required this.dio}) {
    dio.options.baseUrl = sl<EnvType>().domain;
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
  WebService.newDio({
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

    // if the request doesn't need token, then just continue to the next interceptor
    /*if (options.headers[ApiHeader.requiresToken] == false) {
      // and remove the auxiliary header
      options.headers.remove(ApiHeader.requiresToken);
      "Perform request without token".warningLog();
      return handler.next(options);
    }*/

    /* if (!sl.isRegistered<AuthData>()) {
      "AuthData not registered/found in service locator".errorLog();
      return handler.next(options);
    }

    final authData = sl<AuthData>();
    String? accessToken = authData.accessToken;
    final refreshToken = authData.refreshToken;
    if (accessToken.isEmpty || refreshToken.isEmpty) {
      CommonFunctions.signOut();
      return handler.reject(TokenNotFoundException(options));
    }

    final formatter = DateFormat('EEE, d MMM yyyy HH:mm:ss');
    final dateNow = DateTime.now();
    final issuedDate = formatter.parse(authData.issued, true).toLocal();
    if (dateNow.difference(issuedDate).inDays < 15) {
      final expiredDate = formatter.parse(authData.expires, true).toLocal();
      if (dateNow.difference(expiredDate).inMinutes >= 0) {
        final context = NavigationService.navigatorKey.currentContext!;
        final username = authData.username;
        final newAuthData = await _onRefreshToken(
          username: username,
          refreshToken: refreshToken,
        );
        if (newAuthData == null) {
          return handler.reject(FailedToGenerateTokenException(options));
        }

        if (mounted) {
          await context
              .read<EntryPointCubit>()
              .onUpdateAuth(newAuthData.copyWith());
        }
        accessToken = newAuthData.accessToken;
      }
    } else { 
      CommonFunctions.signOut();
      return handler.reject(TokenHasExpiredException(options));
    }*/

    String url = options.uri.toString();
    final method = options.method;

    if (options.headers['Authorization'] == null &&
        CommonProperties.isLoggedIn &&
        !options.uri.toString().contains("bcg/upload-file")) {
      //  options.headers['Authorization'] = 'Bearer ${CommonProperties.token}';
    }

    if (url.contains("damaged-vehicle-mobile/car-models")) {
      url = options.baseUrl + options.path;
      url += "?CompanyID=${options.queryParameters["CompanyID"]}";
    }

    final verifyingKEY = CommonFunctions.hashRequest(url, method,
        body: (options.data != null &&
                !options.uri.toString().contains("bcg/upload-file"))
            ? json.encode(options.data)
            : null,
        authorization: !options.uri.toString().contains("bcg/upload-file")
            ? options.headers.containsKey("Authorization")
            : false);
    options.headers
        .putIfAbsent(ApiHeader.verifyingKEY.name, () => verifyingKEY);
    //if (options.headers['Authorization'] == null) {
    print(options.headers);
    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    "Opps, recieved Error: $err".errorLog();

    "Opps, recieved Error: ${err.response?.statusCode}".errorLog();
    "Opps, recieved Error: ${err.response?.data}".errorLog();

    switch (err.type) {
      case DioErrorType.connectionTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioErrorType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            if (err.response?.data['data']['responseCode'] == '2') {
              throw NoDataFoundException(err.requestOptions);
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
        throw NoInternetConnectionException(err.requestOptions);
    }

    return handler.next(err);
  }

  String get languageCode => translator.activeLanguageCode;
  bool get mounted => true;
}
