import 'package:dio/dio.dart';

import '../../../../../core/errors/errors_exports.dart'
    show NoDataFoundException, ServerException;
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart' show ApiUrl, Log;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;
import '../../delegators_exports.dart' show DelegatorModel;

abstract class DelegatorsRemoteDataSource {
  Future<List<DelegatorModel>> getDelegators();
}

class DelegatorsRemoteDataSourceImplementation
    implements DelegatorsRemoteDataSource {
  final WebService webService;

  DelegatorsRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<DelegatorModel>> getDelegators() async {
    try {
      final response = await webService.dio.get(ApiUrl.delegators);

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
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException(ex.toString());
      }
    }
  }
}
