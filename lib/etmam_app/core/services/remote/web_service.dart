/*import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart';
import 'package:balady_plus/etmam_app/core/services/remote/network_connection.dart';
import 'package:dio/dio.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/api_url.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../utils/utils_exports.dart'
    show ApiUrl, Log, CommonProperties, CommonFunctions;

import '../services_exports.dart' show NetworkConnection;

class WebService {
  final Dio dio;

  WebService({required this.dio}) {
    dio.options.baseUrl = ApiUrl.baseUrl;
    dio.options.connectTimeout = 60000;
    dio.options.receiveTimeout = 60000;
    dio.options.sendTimeout = 60000;
    dio.options.headers = CommonProperties.defaultHeaders;

    dio.interceptors.add(AppInterceptors());
  }
}

class AppInterceptors extends Interceptor {
  late NetworkConnection networkConnection;

  AppInterceptors() {
    networkConnection = sl<NetworkConnection>();
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    "On-Sending-Request".actionLog();
    // print(options.uri);
    await sl<EntryPointCubit>().checkifTokenExpired();

    var headers = {
      ApiHeaders.xFeappId: CommonProperties.appName,
      ApiHeaders.xFeAppVersion: CommonProperties.appVersion,
      ApiHeaders.xFeDeviceId: CommonProperties.deviceId,
      ApiHeaders.xFeDeviceOs: CommonProperties.deviceOs,
      ApiHeaders.xSessionId: CommonProperties.sessionId,
      ApiHeaders.xCorrelationId: CommonFunctions.generateGUID(),
      if (CommonProperties.profileId != null)
        ApiHeaders.xUserProfileId: CommonProperties.profileId
    };

    options.headers.addAll(headers);

    print(options.headers);

    if (await networkConnection.isConnected == false) {
      "Request-Rejected because 'Network-Disconnected'".errorLog();
      return handler.reject(NoInternetConnectionException(options));
    }

    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    "Opps, recieved Error: ${err.response?.statusCode}".errorLog();

    try {
      CommonFunctions.sendSentryLog(
          body: err.requestOptions.data,
          data: err.response?.data,
          qeuryParms: err.requestOptions.queryParameters.toString(),
          url: err.requestOptions.path,
          statusCode: err.response?.statusCode,
          headers: err.requestOptions.headers);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
    }
    switch (err.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);

      case DioErrorType.response:
        switch (err.response?.statusCode) {
          case 400:
            //  return err.response != null
            //     ? handler.resolve(err.response!)
            //    : handler.next(err);
            throw BadRequestException(err.requestOptions, err.response);
          case 401:
            sl<EntryPointCubit>().autoLogout();
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
}
*/
