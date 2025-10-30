import 'dart:convert';

import 'package:smart_advisor/app/core/utils/utils_exports.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/common_functions.dart';
import '../../domain/entities/submit_rating_request.dart';
import '../models/rating_items_response.dart';
import '/app/core/utils/constants/apis/apis_get.dart';
import '/app/features/_shared_feature_/presentation/models/lookUp_response_model.dart';
import '/app/features/fees_calculator/data/models/fees_calculator_response_model.dart';
import '/app/features/fees_calculator/domain/entities/fees_calculator_request.dart';
import 'package:dio/dio.dart' show DioError, Options;
import '/app/core/utils/constants/language.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

import '../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../core/services/services_exports.dart'
    show SmartAdvisorWebService;
import '../../../_shared_feature_/presentation/models/response_body_model.dart';

abstract class RemoteDataSource {
  Future<RatingItemsResponseModel> getRatingItems(int activityId);
  Future<double> submitRatingItems(SubmitRatingRequest request);
}

class RemoteDataSourceImplementation implements RemoteDataSource {
  final SmartAdvisorWebService webService;

  RemoteDataSourceImplementation({required this.webService});

  @override
  Future<RatingItemsResponseModel> getRatingItems(int activityId) async {
    try {
      final response =
          await webService.dio.get(ApiUrls.selfRatingItems(activityId));
      print(response.data);

      final result = ResponseBodyModel<RatingItemsResponseModel>.fromMap(
              response.data,
              parsedResult:
                  RatingItemsResponseModel.fromJson(response.data["data"]))
          .data
          ?.result;

      return result!;
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
  Future<double> submitRatingItems(SubmitRatingRequest request) async {
    try {
      final verifyingKEY = CommonFunctions.hashRequest(
        sl<EnvType>().domain + ApiUrls.submitRatingItems, "POST",
        body: json.encode(
          request.toJson(),
        ),
        //  authorization: BaladyServices.token.isNotEmpty ? true : false
      );

      final response = await webService.dio.post(ApiUrls.submitRatingItems,
          data: request.toJson(),
          options: Options(headers: {"verifyingKEY": verifyingKEY}));
      print(response.data);

      final result =
          response.data["data"]["result"]["DegreeOfCompliance"]?.toDouble();

      return result!;
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
