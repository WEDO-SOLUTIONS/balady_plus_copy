import 'dart:convert';

import 'package:smart_advisor/app/core/dependency_injection/injection_container.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/apis/env_types.dart';
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

abstract class CalculatorRemoteDataSource {
  Future<FeesCalculatorResponseModel> calculateFees(
      FeesCalculatorRequest params);
}

class CalculatorRemoteDataSourceImplementation
    implements CalculatorRemoteDataSource {
  final SmartAdvisorWebService webService;

  CalculatorRemoteDataSourceImplementation({required this.webService});

  @override
  Future<FeesCalculatorResponseModel> calculateFees(
      FeesCalculatorRequest params) async {
    try {
      final verifyingKEY = CommonFunctions.hashRequest(
        sl<EnvType>().domain + ApiUrls.calculateFees, "POST",
        body: json.encode(params.toJson()),
        // authorization: BaladyServices.token.isNotEmpty ? true : false
      );

      final response = await webService.dio.post(ApiUrls.calculateFees,
          data: params.toJson(),
          options: Options(headers: {"verifyingKEY": verifyingKEY}));
      print(response.data);

      final result = ResponseBodyModel<FeesCalculatorResponseModel>.fromMap(
              response.data,
              parsedResult: FeesCalculatorResponseModel.fromJson(
                  response.data["data"]["result"]))
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
}
