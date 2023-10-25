import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/errors/errors_exports.dart'
    show APIException, NoDataFoundException, ServerException;
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart' show ApiUrl, Log;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;
import '../../delegators_exports.dart' show DelegatorModel, AgentModel;

abstract class DelegatorsRemoteDataSource {
  Future<List<DelegatorModel>> getDelegators();
  Future<List<AgentModel>> getAgents();
}

class DelegatorsRemoteDataSourceImplementation
    implements DelegatorsRemoteDataSource {
  final WebService webService;

  DelegatorsRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<DelegatorModel>> getDelegators() async {
    var response;
    try {
      response = await webService.dio.get(ApiUrl.delegators);

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<DelegatorModel>(
              (e) => DelegatorModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        rethrow;
      }
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<AgentModel>> getAgents() async {
    var response;
    try {
      response = await webService.dio.get(ApiUrl.agents);

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<AgentModel>((e) => AgentModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();

      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: ex.toString(),
            ),
            response: response);
      }
    }
  }
}
