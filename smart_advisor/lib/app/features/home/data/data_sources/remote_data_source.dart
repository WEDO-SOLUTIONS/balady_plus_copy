import '/app/core/utils/constants/apis/apis_get.dart';
import '/app/core/utils/extensions/delay.dart';
import '/app/features/home/home_exports.dart';
import 'package:dio/dio.dart' show DioError;
import '/app/core/utils/constants/language.dart';

import '../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../core/services/services_exports.dart' show SmartAdvisorWebService;

abstract class SmartAdvisorHomeRemoteDataSource {
  Future<NewsResponse> getNews(NewsParams params);
}

class SmartAdvisorHomeRemoteDataSourceImplementation
    implements SmartAdvisorHomeRemoteDataSource {
  final SmartAdvisorWebService webService;

  SmartAdvisorHomeRemoteDataSourceImplementation({required this.webService});

  @override
  Future<NewsResponseModel> getNews(NewsParams params) async {
    try {
      final response = await webService.dio
          .get(ApiUrls.permitsForActivites, queryParameters: params.toMap());
      final decodedResponse = NewsResponseModel.fromMap(response.data);
      return decodedResponse.toFuture();
    } on DioError catch (error) {
      throw ServerException(error.toString());
    } catch (ex) {
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errorsServerError".tr());
      }
    }
  }
}
