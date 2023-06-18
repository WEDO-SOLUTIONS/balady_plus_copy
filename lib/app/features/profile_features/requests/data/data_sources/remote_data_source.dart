import 'package:dio/dio.dart' show DioError;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart' show ApiUrl, Log;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;
import '../../requests_exports.dart'
    show
        MunicipalityModel,
        RequestsModel,
        RequestStatusModel,
        RequestSubTypeModel,
        RequestSubTypeParamsModel,
        RequestTypeModel,
        RequestsParamsModel,
        SubMunicipalityModel,
        SubMunicipalityParamsModel;

abstract class RequestsRemoteDataSource {
  Future<List<RequestsModel>> getRequests(
    RequestsParamsModel params,
  );
  Future<List<RequestStatusModel>> getRequestStatuses();
  Future<List<MunicipalityModel>> getMunicipalities();
  Future<List<SubMunicipalityModel>> getSubMunicipalities(
    SubMunicipalityParamsModel params,
  );
  Future<List<RequestTypeModel>> getRequestTypes();
  Future<List<RequestSubTypeModel>> getRequestSubTypes(
    RequestSubTypeParamsModel params,
  );
}

class RequestsRemoteDataSourceImplementation
    implements RequestsRemoteDataSource {
  final WebService webService;

  RequestsRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<RequestsModel>> getRequests(
    RequestsParamsModel params,
  ) async {
    try {
      final response = await webService.dio.post(
        ApiUrl.requests,
        data: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data.result;

      return result
          .map<RequestsModel>(
              (e) => RequestsModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
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
  Future<List<RequestStatusModel>> getRequestStatuses() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.requestStatuses,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data.result;

      return result
          .map<RequestStatusModel>(
              (e) => RequestStatusModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
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
  Future<List<MunicipalityModel>> getMunicipalities() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.municipalities,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data.result;

      return result
          .map<MunicipalityModel>(
              (e) => MunicipalityModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
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
  Future<List<SubMunicipalityModel>> getSubMunicipalities(
    SubMunicipalityParamsModel params,
  ) async {
    try {
      final response = await webService.dio.get(
        ApiUrl.subMunicipalities(params.id),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data.result;

      return result
          .map<SubMunicipalityModel>(
              (e) => SubMunicipalityModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
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
  Future<List<RequestTypeModel>> getRequestTypes() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.requestTypes,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data.result;

      return result
          .map<RequestTypeModel>(
              (e) => RequestTypeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
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
  Future<List<RequestSubTypeModel>> getRequestSubTypes(
    RequestSubTypeParamsModel params,
  ) async {
    try {
      final response = await webService.dio.get(
        ApiUrl.requestSubTypes(params.id),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data.result;

      return result
          .map<RequestSubTypeModel>(
              (e) => RequestSubTypeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
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
