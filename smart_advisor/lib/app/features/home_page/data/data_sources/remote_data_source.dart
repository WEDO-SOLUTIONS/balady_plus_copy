import '../models/search_isic_model.dart';
import '/app/core/utils/constants/apis/apis_get.dart';
import '/app/features/_shared_feature_/presentation/models/lookUp_response_model.dart';
import 'package:dio/dio.dart' show DioError;
import '/app/core/utils/constants/language.dart';

import '../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../core/services/services_exports.dart'
    show SmartAdvisorWebService;
import '../../../_shared_feature_/presentation/models/response_body_model.dart';

abstract class SmartAdvisorHomeRemoteDataSource {
  Future<LookUpResponseModel> getSectors();
  Future<List<SearchIsicModel>> searchIsics(String keyword);
}

class SmartAdvisorHomeRemoteDataSourceImplementation
    implements SmartAdvisorHomeRemoteDataSource {
  final SmartAdvisorWebService webService;

  SmartAdvisorHomeRemoteDataSourceImplementation({required this.webService});

  @override
  Future<LookUpResponseModel> getSectors() async {
    try {
      final response = await webService.dio.get(
        ApiUrls.getSectors,
      );
      print(response.data);

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      var res = result
              ?.map<LookUpItemModel>(
                  (e) => LookUpItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      return LookUpResponseModel(items: res);
    } on DioError catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      print(ex);
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errorsServerError".tr());
      }
    }
  }

  @override
  Future<List<SearchIsicModel>> searchIsics(String keyword) async {
    try {
      final response = await webService.dio
          .get(ApiUrls.search, queryParameters: {"keyword": keyword});
      print(response.data);

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      var res = result
              ?.map<SearchIsicModel>(
                  (e) => SearchIsicModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      return res;
    } on DioError catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      print(ex);
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errorsServerError".tr());
      }
    }
  }
}
