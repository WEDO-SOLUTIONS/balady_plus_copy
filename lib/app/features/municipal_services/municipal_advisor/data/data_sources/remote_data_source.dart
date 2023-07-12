import 'package:dio/dio.dart' show DioError;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart' show ApiUrl, Log;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;
import '../../municipal_advisor_exports.dart'
    show
        ActivityDetailsModel,
        ActivityDetailsParamsModel,
        IsicActivityModel,
        IsicSubActivityParamsModel;

abstract class MunicipalAdvisorRemoteDataSource {
  Future<List<IsicActivityModel>> getIsicActivities();
  Future<List<IsicActivityModel>> getIsicSubActivities(
      IsicSubActivityParamsModel params);
  Future<ActivityDetailsModel> getActivityDetails(
      ActivityDetailsParamsModel params);
}

class MunicipalAdvisorRemoteDataSourceImplementation
    implements MunicipalAdvisorRemoteDataSource {
  final WebService webService;

  MunicipalAdvisorRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<IsicActivityModel>> getIsicActivities() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.isicActivities,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<IsicActivityModel>(
              (e) => IsicActivityModel.fromMap(e as Map<String, dynamic>))
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
  Future<List<IsicActivityModel>> getIsicSubActivities(
      IsicSubActivityParamsModel params) async {
    try {
      final response = await webService.dio.get(
        ApiUrl.isicSubActivities,
        queryParameters: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<IsicActivityModel>(
              (e) => IsicActivityModel.fromMap(e as Map<String, dynamic>))
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
  Future<ActivityDetailsModel> getActivityDetails(
      ActivityDetailsParamsModel params) async {
    try {
      final response = await webService.dio.get(
        "${ApiUrl.activityDetails}/${params.id}",
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return ActivityDetailsModel.fromMap(result as Map<String, dynamic>);
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
