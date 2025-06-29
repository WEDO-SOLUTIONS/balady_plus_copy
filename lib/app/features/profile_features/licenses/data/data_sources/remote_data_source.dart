import 'package:dio/dio.dart' show DioException;
import 'package:dio/src/response.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../../core/errors/errors_exports.dart'
    show APIException, NoDataFoundException, ServerException;
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart' show ApiUrl, Log;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;
import '../../licenses_exports.dart'
    show
        LicensesModel,
        LicenseStatusModel,
        LicenseSubTypeModel,
        LicenseSubTypeParamsModel,
        LicenseTypeModel,
        LicensesParamsModel;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class LicensesRemoteDataSource {
  Future<List<LicensesModel>> getLicenses(
    LicensesParamsModel params,
  );
  Future<List<LicenseStatusModel>> getLicenseStatuses();
  Future<List<LicenseTypeModel>> getLicenseTypes();
  Future<List<LicenseSubTypeModel>> getLicenseSubTypes(
    LicenseSubTypeParamsModel params,
  );
}

class LicensesRemoteDataSourceImplementation
    implements LicensesRemoteDataSource {
  final WebService webService;

  LicensesRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<LicensesModel>> getLicenses(
    LicensesParamsModel params,
  ) async {
    dynamic response;
    try {
      response = await webService.dio.post(
        ApiUrl.licenses,
        data: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      // Enhanced logging for debugging
      print('🔵 API Response: \\${data.toString()}');
      print('🔵 Response type: \\${data.runtimeType}');
      if (data == null) {
        throw ServerException(
          "API returned null response",
          statusCode: response.statusCode,
        );
      }
      try {
        final responseBody = ResponseBodyModel.fromMap(data);
        if (responseBody.data == null) {
          throw ServerException(
            "Response data is null",
            response: response,
          );
        }
        final result = responseBody.data!.result;
        if (result == null) {
          throw ServerException(
            "Result is null in the response",
            response: response,
          );
        }
        if (result is! List) {
          throw ServerException(
            "Expected List but got \\${result.runtimeType}",
            response: response,
          );
        }
        return result.map<LicensesModel>((e) {
          try {
            return LicensesModel.fromMap(e as Map<String, dynamic>);
          } catch (e) {
            print('❌ Error parsing license item: \\${e.toString()}');
            print('❌ Problematic item: \\${e.toString()}');
            rethrow;
          }
        }).toList();
      } catch (e, stackTrace) {
        print('❌ Error parsing response: \\${e.toString()}');
        print('❌ Stack trace: \\${stackTrace.toString()}');
        rethrow;
      }
    } on DioException catch (error, stackTrace) {
      final errorMessage = 'DioError: \\${error.message}\\n'
          'Status: \\${error.response?.statusCode}\\n'
          'Response: \\${error.response?.data}';
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: errorMessage,
          stackTrace: stackTrace.toString(),
        ),
      );
      errorMessage.errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        errorMessage,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      final errorMessage = 'Unexpected error: \\${error.toString()}\\n'
          'Response: \\${response?.data}';
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: errorMessage,
          stackTrace: stackTrace.toString(),
        ),
      );
      errorMessage.errorLog();
      if (error is ServerException) {
        rethrow;
      }
      throw ServerException(
        "errors_server_error_2".tr(),
        exception: APIException(errorMessage: error.toString()),
        response: response,
      );
    }
  }

  @override
  Future<List<LicenseStatusModel>> getLicenseStatuses() async {
    Response? response;

    try {
      response = await webService.dio.get(
        ApiUrl.licenseStatuses,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<LicenseStatusModel>(
              (e) => LicenseStatusModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<LicenseTypeModel>> getLicenseTypes() async {
    Response? response;

    try {
      response = await webService.dio.get(
        ApiUrl.licenseTypes,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<LicenseTypeModel>(
              (e) => LicenseTypeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<LicenseSubTypeModel>> getLicenseSubTypes(
    LicenseSubTypeParamsModel params,
  ) async {
    Response? response;

    try {
      response = await webService.dio.get(
        ApiUrl.licenseSubTypes(params.id),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<LicenseSubTypeModel>(
              (e) => LicenseSubTypeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }
}
