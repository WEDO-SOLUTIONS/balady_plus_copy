import 'package:dio/dio.dart' show DioError;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../../core/errors/errors_exports.dart'
    show NoDataFoundException, ServerException;
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
    try {
      final response = await webService.dio.post(
        ApiUrl.licenses,
        data: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<LicensesModel>(
              (e) => LicensesModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<LicenseStatusModel>> getLicenseStatuses() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.licenseStatuses,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<LicenseStatusModel>(
              (e) => LicenseStatusModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<LicenseTypeModel>> getLicenseTypes() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.licenseTypes,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<LicenseTypeModel>(
              (e) => LicenseTypeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<LicenseSubTypeModel>> getLicenseSubTypes(
    LicenseSubTypeParamsModel params,
  ) async {
    try {
      final response = await webService.dio.get(
        ApiUrl.licenseSubTypes(params.id),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<LicenseSubTypeModel>(
              (e) => LicenseSubTypeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }
}
