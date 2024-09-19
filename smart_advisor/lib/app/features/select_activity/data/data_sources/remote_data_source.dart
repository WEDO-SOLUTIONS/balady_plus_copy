import '/app/core/utils/constants/apis/apis_get.dart';
import '/app/core/utils/extensions/delay.dart';
import '/app/features/_shared_feature_/presentation/models/lookUp_response_model.dart';
import '/app/features/home/home_exports.dart';
import '/app/features/select_activity/data/models/permits_response_model.dart';
import '/app/features/select_activity/domain/entities/activity_request_params.dart';
import '/app/features/select_activity/domain/entities/categories_request_params.dart';
import '/app/features/select_activity/domain/entities/isics_request_params.dart';
import '/app/features/select_activity/domain/entities/rubrics_request_params.dart';
import 'package:dio/dio.dart' show DioError;
import '/app/core/utils/constants/language.dart';

import '../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../core/services/services_exports.dart'
    show SmartAdvisorWebService;
import '../../../_shared_feature_/presentation/models/response_body_model.dart';
import '../../domain/entities/permit_request_params.dart';
import '../models/addetional_activites_response_model.dart';

abstract class ActivitesRemoteDataSource {
  Future<List<AddetionalActivityItemModel>> getAddetionalActivites(
      String params);

  Future<List<PermitItemModel>> getPermits(PermitRequestParams params);

  Future<LookUpResponseModel> getSectors();

  Future<List<LookUpItemModel>> getCategories(CategoriesRequestParams params);

  Future<List<LookUpItemModel>> getRubrics(RubricsRequestParams params);

  Future<List<LookUpItemModel>> getIsics(IsicsRequestParams params);

  Future<List<LookUpItemModel>> getActivites(ActivityRequestParams params);
}

class ActivitesRemoteDataSourceImplementation
    implements ActivitesRemoteDataSource {
  final SmartAdvisorWebService webService;

  ActivitesRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<AddetionalActivityItemModel>> getAddetionalActivites(
      String params) async {
    try {
      final response = await webService.dio.get(
        ApiUrls.addetionalActivites(params),
      );
      print(response.data);
      /*final result =
          ResponseBodyModel<List<AddetionalActivityItemModel>>.fromMap(
                  response.data)
              .data
              ?.result;*/

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return result
              ?.map<AddetionalActivityItemModel>((e) =>
                  AddetionalActivityItemModel.fromJson(
                      e as Map<String, dynamic>))
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
  Future<List<PermitItemModel>> getPermits(PermitRequestParams params) async {
    try {
      final response = await webService.dio
          .get(ApiUrls.permitsForActivites, queryParameters: params.toMap());
      print(response.data);

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return result
              ?.map<PermitItemModel>(
                  (e) => PermitItemModel.fromJson(e as Map<String, dynamic>))
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
  Future<List<LookUpItemModel>> getCategories(
      CategoriesRequestParams params) async {
    try {
      final response = await webService.dio.get(
        ApiUrls.getcategories(params.sectorID),
      );
      print(response.data);

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return result
              ?.map<LookUpItemModel>(
                  (e) => LookUpItemModel.fromJson(e as Map<String, dynamic>))
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
  Future<List<LookUpItemModel>> getRubrics(RubricsRequestParams params) async {
    try {
      final response = await webService.dio.get(
        ApiUrls.getrubrics(params.rubricsID),
      );
      print(response.data);

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return result
              ?.map<LookUpItemModel>(
                  (e) => LookUpItemModel.fromJson(e as Map<String, dynamic>))
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
  Future<List<LookUpItemModel>> getIsics(IsicsRequestParams params) async {
    try {
      final response = await webService.dio.get(
          ApiUrls.getIsics(params.categoryId),
          queryParameters: {"rubricId": params.rubricId});
      print(response.data);

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return result
              ?.map<LookUpItemModel>(
                  (e) => LookUpItemModel.fromJson(e as Map<String, dynamic>))
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
  Future<List<LookUpItemModel>> getActivites(
      ActivityRequestParams params) async {
    try {
      final response = await webService.dio.get(
        ApiUrls.getActivites(params.isicId),
      );
      print(response.data);

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return result
              ?.map<LookUpItemModel>(
                  (e) => LookUpItemModel.fromJson(e as Map<String, dynamic>))
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
