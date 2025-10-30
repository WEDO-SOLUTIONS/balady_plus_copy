import '/app/core/utils/constants/apis/apis_get.dart';
import '/app/features/details/data/models/entity_activity_details_response_model.dart';
import '/app/features/details/data/models/entity_violation_activity_details_model.dart';
import '/app/features/details/data/models/entity_violation_activity_model.dart';
import '/app/features/details/data/models/regulation_response_model.dart';
import '/app/features/details/data/models/violation_details_vd_model.dart';
import '/app/features/details/domain/entities/entity_activity_details_request_params.dart';
import '/app/features/details/domain/entities/entity_activity_details_response.dart';
import '/app/features/details/domain/entities/entity_violation_activity_details_request_params.dart';
import '/app/features/details/domain/entities/entity_violation_activity_request_params.dart';
import '/app/features/details/domain/entities/violation_details_vd_request_params.dart';
import 'package:dio/dio.dart' show DioError, Options;
import '/app/core/utils/constants/language.dart';

import '../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../core/services/services_exports.dart' show SmartAdvisorWebService;
import '../../../_shared_feature_/presentation/models/response_body_model.dart';
import '../../domain/entities/regulation_request_params.dart';

abstract class DetailsRemoteDataSource {
  Future<RegulationResponseModel> getRegulations(RegulationRequestParams params);

  Future<EntityActivityDetailsResponse> getEntityActivityDetails(EntityActivityDetailRequestParams params);

  Future<List<EntityViolationActivityModel>> getEntityViolationActivity(EntityViolationActivityRequestParams params);

  Future<EntityViolationActivityDetailsModel> getEntityViolationActivityDetails(
      EntityViolationActivityDetailsRequestParams params);

  Future<List<ViolationDetailsVdModel>> getEntityViolationDetailsVd(ViolationDetailsVdRequestParams params);
}

class DetailsRemoteDataSourceImplementation implements DetailsRemoteDataSource {
  final SmartAdvisorWebService webService;

  DetailsRemoteDataSourceImplementation({required this.webService});

  @override
  Future<RegulationResponseModel> getRegulations(RegulationRequestParams params) async {
    try {
      final response =
          await webService.dio.get(ApiUrls.detailsRegulations(params.activityId), queryParameters: params.toMap());
      print(response.data);

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return RegulationResponseModel.fromJson(result);
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
  Future<EntityActivityDetailsResponse> getEntityActivityDetails(EntityActivityDetailRequestParams params) async {
    try {
      final response = await webService.dio.get(ApiUrls.entityActivityDetails, queryParameters: params.toMap());
      print(response.data);

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return EntityActivityDetailsResponseModel.fromJson(result);
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
  Future<List<EntityViolationActivityModel>> getEntityViolationActivity(
      EntityViolationActivityRequestParams params) async {
    try {
      final response = await webService.dio.get(
        ApiUrls.getViolationEntityActivity(params.activityId),
        queryParameters: params.toMap(),
      );
      print(response.data);

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return result
              ?.map<EntityViolationActivityModel>(
                  (e) => EntityViolationActivityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
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
  Future<EntityViolationActivityDetailsModel> getEntityViolationActivityDetails(
      EntityViolationActivityDetailsRequestParams params) async {
    try {
      final response = await webService.dio.get(
        ApiUrls.getViolationEntityActivityDetails(params.activityID),
        queryParameters: params.toMap(),
      );
      print(response.data);

      final result = ResponseBodyModel<EntityViolationActivityDetailsModel>.fromMap(response.data,
              parsedResult: EntityViolationActivityDetailsModel.fromJson(response.data["data"]["result"][0]))
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
  Future<List<ViolationDetailsVdModel>> getEntityViolationDetailsVd(ViolationDetailsVdRequestParams params) async {
    try {
      final response = await webService.dio.get(
        ApiUrls.getViolationDetailsVD(params.activityId),
        queryParameters: params.toMap(),
      );
      print(response.data);

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return result
              ?.map<ViolationDetailsVdModel>((e) => ViolationDetailsVdModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
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
