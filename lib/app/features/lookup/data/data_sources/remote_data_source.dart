import 'package:dio/dio.dart' show DioError;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../core/services/services_exports.dart' show WebService;
import '../../../../core/utils/utils_exports.dart'
    show ApiGET, LookupItemsModel, LookupKey, WithDelay;
import '../../lookup_exports.dart' show LookupParamsModel;

abstract class LookupRemoteDataSource {
  Future<LookupItemsModel> lookup(LookupParamsModel params);
}

class LookupRemoteDataSourceImplementation implements LookupRemoteDataSource {
  final WebService webService;
  LookupRemoteDataSourceImplementation({required this.webService});

  @override
  Future<LookupItemsModel> lookup(LookupParamsModel params) async {
    try {
      if (params.key == LookupKey.empty) {
        throw const ServerException("Please identify Lookup-Key");
      }

      String url =
          "${ApiGET.lookups.url}/${params.key.name}/${params.filterValue}";

      final response =
          await webService.dio.get(url, queryParameters: params.queryParams);

      final decodedResponse = LookupItemsModel.itemsFromMap(response.data);
      return decodedResponse.toFuture();
    } on DioError catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }
}
