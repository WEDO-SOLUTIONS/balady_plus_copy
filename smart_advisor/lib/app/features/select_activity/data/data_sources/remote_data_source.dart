import 'package:smart_advisor/app/features/select_activity/data/models/work_flow_model.dart';
import 'package:smart_advisor/app/features/select_activity/domain/entities/work_flow_request_params.dart';

import '../models/activity_details_info.dart';
import '../models/new_activites_model.dart';
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

  Future<List<LookUpItemModel>> getCities();

  Future<List<LookUpItemModel>> getDistricts(int cityId);

  Future<List<WorkFlowModel>> getWorkFlow(WorkFlowRequestParams params);

  Future<ActivityDetailsInfo> getActivityDetailsInfo(int id);
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

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return result
              ?.map<AddetionalActivityItemModel>((e) =>
                  AddetionalActivityItemModel.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          [];
    } on DioError catch (error) {
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<AddetionalActivityItemModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (ex) {}

      throw ServerException(error.toString(), errorCode: errorCode);
    } catch (ex) {
      print("Here");
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
    final uniqueIds = <int>{};

    var r = allRegulationsData
        .where((regulation) =>
            uniqueIds.add(regulation.categoryId)) // Ensures uniqueness
        .map((regulation) => LookUpItemModel(
            id: regulation.categoryId,
            name: regulation.categoryName,
            count: regulation.categorySum))
        .toList();

    return LookUpResponseModel(items: r);

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
    final uniqueSubCategoryIds = <int>{};

    var subCategories = allRegulationsData
        .where((regulation) =>
            regulation.categoryId == params.sectorID && // Filter by categoryId
            uniqueSubCategoryIds.add(regulation
                .subCategoryId!)) // Ensures uniqueness of subCategoryId
        .map((regulation) => LookUpItemModel(
              id: regulation.subCategoryId,
              name: regulation.subCategory,
              count: regulation.subCategorySum,
            ))
        .toList();

    return subCategories;

    return [
      LookUpItemModel(id: 1, name: "مواد غذائية / مشروبات"),
      LookUpItemModel(id: 2, name: "خدمات غذائية / ترفيهية / إحتفالية"),
      LookUpItemModel(id: 3, name: "ملابس / أحذية"),
      LookUpItemModel(id: 4, name: "مراكز تسوق / متاجر متخصصة"),
      LookUpItemModel(id: 5, name: "طب / صحة / جمال"),
      LookUpItemModel(id: 6, name: "مفروشات / مواد / تجهيزات أثاث"),
      LookUpItemModel(id: 7, name: "إنشاءات / عقارات / ترميمات"),
      LookUpItemModel(id: 8, name: "إنترنت / إتصالات / تقنية معلومات"),
      LookUpItemModel(id: 9, name: "أقمشة / ديكورات منزلية"),
      LookUpItemModel(id: 10, name: "أعمال إنشاء / تشطيب"),
      LookUpItemModel(id: 11, name: "خدمة مركبات / إكسسوارات سيارات"),
      LookUpItemModel(id: 12, name: "أدوات منزلية / قرطاسية / تغليف"),
      LookUpItemModel(id: 13, name: "معدات / أدوات"),
      LookUpItemModel(
          id: 14, name: "أجهزة كمبيوتر / أجهزة منزلية / أدوات مكتبية"),
      LookUpItemModel(id: 15, name: "رياضات / ترفية / سياحة"),
      LookUpItemModel(id: 16, name: "معادن / وقود / كيماويات"),
      LookUpItemModel(id: 17, name: "مستلزمات حيوانات أليفة / طب بيطري"),
      LookUpItemModel(id: 18, name: "إلكترونيات / معدات كهربائية"),
      LookUpItemModel(id: 19, name: "حماية / أمن"),
      LookUpItemModel(id: 20, name: "ثقافة / فنون / تعاليم دينية"),
      LookUpItemModel(id: 21, name: "خدمية / إستهلاكية / خدمات دفن"),
      LookUpItemModel(id: 22, name: "وسائل نقل / نقل بضائع"),
      LookUpItemModel(id: 23, name: "خدمات قانونية / مالية / تجارية"),
      LookUpItemModel(id: 24, name: "مؤسسات حكومية"),
      LookUpItemModel(id: 25, name: "تعليم / وظائف / مهن"),
      LookUpItemModel(id: 26, name: "خدمات طوارئ / إستعلامات"),
      LookUpItemModel(id: 27, name: "دعاية وإعلان / طباعة / وسائل إعلام"),
    ];

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
          queryParameters: {"categoryId": params.categoryId});
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
    final uniqueActivityIds = <int>{};

    var activities = allRegulationsData
        .where((regulation) =>
            regulation.subCategoryId ==
                params.isicId && // Filter by subCategoryId
            uniqueActivityIds.add(regulation
                .dActivitiesId)) // Ensures uniqueness of dActivitiesId
        .map((regulation) => LookUpItemModel(
              id: regulation.dActivitiesId,
              name: regulation.dActivitiesName,
              count: regulation.activitiesSum,
            ))
        .toList();

    return activities;
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

  @override
  Future<List<LookUpItemModel>> getCities() async {
    try {
      final response = await webService.dio.get(
        ApiUrls.getCities(),
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
  Future<List<LookUpItemModel>> getDistricts(int cityId) async {
    try {
      final response = await webService.dio.get(
        ApiUrls.getDistricts(cityId),
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
  Future<List<WorkFlowModel>> getWorkFlow(WorkFlowRequestParams params) async {
    try {
      final response = await webService.dio
          .get(ApiUrls.getWorkFlow, queryParameters: params.toJson());
      print(response.data);

      final result = ResponseBodyModel.fromMap(response.data).data?.result;

      return result
              ?.map<WorkFlowModel>(
                  (e) => WorkFlowModel.fromJson(e as Map<String, dynamic>))
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
  Future<ActivityDetailsInfo> getActivityDetailsInfo(int id) async {
    try {
      final response =
          await webService.dio.get(ApiUrls.activityDetailsInfo(id));
      print(response.data);

      final result = ResponseBodyModel<ActivityDetailsInfo>.fromMap(
              response.data,
              parsedResult:
                  ActivityDetailsInfo.fromJson(response.data["data"]["result"]))
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
