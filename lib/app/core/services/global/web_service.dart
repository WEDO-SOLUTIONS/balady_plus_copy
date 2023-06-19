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
class WebService {
  final Dio dio;

  WebService({required this.dio}) {
    dio.options.baseUrl = sl<EnvType>().domain;
    dio.options.connectTimeout = 60000;
    dio.options.receiveTimeout = 60000;
    dio.options.sendTimeout = 60000;
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

    final url = options.uri.toString();
    final method = options.method;
    final verifyingKEY = CommonFunctions.hashRequest(url, method);
    options.headers
        .putIfAbsent(ApiHeader.verifyingKEY.name, () => verifyingKEY);
    //if (options.headers['Authorization'] == null) {
    options.headers['Authorization'] = 'Bearer ${CommonProperties.token}';
    //  }
    print(options.headers);
    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    "Opps, recieved Error: ${err.response?.statusCode}".errorLog();
    "Opps, recieved Error: ${err.response?.data}".errorLog();

    switch (err.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioErrorType.response:
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
      case DioErrorType.other:
        throw NoInternetConnectionException(err.requestOptions);
    }

    return handler.next(err);
  }

  Future<AuthDataModel?> _onRefreshToken({
    required String username,
    required String refreshToken,
  }) async {
    try {
      // should create new dio instance because the request interceptor is being locked
      var dio = Dio();
      dio.options.baseUrl = sl<EnvType>().domain;
      dio.options.headers = {ApiHeader.language.eName: languageCode};
      final response = await dio.post(
        ApiPOST.refreshToken.url,
        queryParameters: {
          ApiParam.username.name: username,
          ApiParam.refreshToken.name: refreshToken,
        },
      );
      "Token has been refreshed successfully".successLog();
      final decodedResponse = AuthDataModel.fromJson(response.data);
      return decodedResponse.toFuture();
    } on DioError catch (e) {
      "DioError occured ${e.error}".errorLog();
      return null;
    } catch (e) {
      "Catched error occured $e".errorLog();
      return null;
    }
  }

  String get languageCode => translator.activeLanguageCode;
  bool get mounted => true;
}
