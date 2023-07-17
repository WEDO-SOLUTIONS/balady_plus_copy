import 'package:dio/dio.dart' show DioError;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../../core/errors/errors_exports.dart' show ServerException;
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart' show ApiUrl, Log;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;
import '../../municipal_advisor_exports.dart'
    show
        AccommodationTypeEntity,
        AccommodationTypeModel,
        ActivityDetailsModel,
        ActivityDetailsParamsModel,
        BoardTypeEntity,
        BoardTypeModel,
        CalculateFeesParamsModel,
        CleaningEntity,
        CleaningModel,
        CommercialOfficeEntity,
        CommercialOfficeModel,
        ConsultationKeyParamsModel,
        GetLicenseYearsParamsModel,
        IsicActivityModel,
        IsicSubActivityParamsModel,
        KeyParamsModel,
        LicenseFeesEntity,
        LicenseFeesModel,
        LicensePermitEntity,
        LicensePermitModel,
        SaveActivitiesParamsModel,
        SaveConsultationProgressParamsModel,
        SupervisingAuthorityEntity,
        SupervisingAuthorityModel;

abstract class MunicipalAdvisorRemoteDataSource {
  Future<List<IsicActivityModel>> getIsicActivities();
  Future<List<IsicActivityModel>> getIsicSubActivities(
    IsicSubActivityParamsModel params,
  );
  Future<ActivityDetailsModel> getActivityDetails(
    ActivityDetailsParamsModel params,
  );
  Future<List<AccommodationTypeEntity>> getAccommodationTypes();
  Future<String> getConsultationKey(ConsultationKeyParamsModel params);
  Future<List<String>> getIssuingPredefinedConditions();
  Future<List<LicensePermitEntity>> getLicensePermits(KeyParamsModel params);
  Future<List<SupervisingAuthorityEntity>> getSupervisingAuthorities(
    KeyParamsModel params,
  );
  Future<List<String>> getCivilDefensePredefinedConditions(
    KeyParamsModel params,
  );
  Future<List<CleaningEntity>> getCleaningMechanisms(
    KeyParamsModel params,
  );
  Future<List<CommercialOfficeEntity>> getCommercialOffices(
    KeyParamsModel params,
  );
  Future<bool> saveConsultationProgress(
    SaveConsultationProgressParamsModel params,
  );
  Future<bool> saveActivities(
    SaveActivitiesParamsModel params,
  );
  Future<List<int>> getLicenseYears(
    GetLicenseYearsParamsModel params,
  );
  Future<List<BoardTypeEntity>> getBoardTypes();
  Future<LicenseFeesEntity> calculateLicenseFees(
    CalculateFeesParamsModel params,
  );
}

class MunicipalAdvisorRemoteDataSourceImplementation
    implements MunicipalAdvisorRemoteDataSource {
  final WebService webService;

  MunicipalAdvisorRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<IsicActivityModel>> getIsicActivities() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.isicActivities,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<IsicActivityModel>(
              (e) => IsicActivityModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<IsicActivityModel>> getIsicSubActivities(
      IsicSubActivityParamsModel params) async {
    try {
      final response = await webService.dio.get(
        ApiUrl.isicSubActivities,
        queryParameters: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<IsicActivityModel>(
              (e) => IsicActivityModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<ActivityDetailsModel> getActivityDetails(
      ActivityDetailsParamsModel params) async {
    try {
      final response = await webService.dio.get(
        "${ApiUrl.activityDetails}/${params.id}",
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return ActivityDetailsModel.fromMap(result as Map<String, dynamic>);
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<AccommodationTypeEntity>> getAccommodationTypes() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.accommodationTypes,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<AccommodationTypeEntity>(
            (e) => AccommodationTypeModel.fromMap(e as Map<String, dynamic>),
          )
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<String> getConsultationKey(ConsultationKeyParamsModel params) async {
    try {
      final response = await webService.dio.post(
        ApiUrl.consultationKey,
        data: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result['uniqueKey'] as String;
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<String>> getIssuingPredefinedConditions() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.issuingPredefinedConditions,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result.map<String>((e) => e as String).toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<LicensePermitEntity>> getLicensePermits(
      KeyParamsModel params) async {
    try {
      final response =
          await webService.dio.get('${ApiUrl.licensePermits}/${params.key}');

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<LicensePermitEntity>(
              (e) => LicensePermitModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<SupervisingAuthorityEntity>> getSupervisingAuthorities(
      KeyParamsModel params) async {
    try {
      final response = await webService.dio
          .get('${ApiUrl.supervisingAuthorities}/${params.key}');

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<SupervisingAuthorityEntity>((e) =>
              SupervisingAuthorityModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<String>> getCivilDefensePredefinedConditions(
    KeyParamsModel params,
  ) async {
    try {
      final predefinedConditionsResponse = await webService.dio.get(
        ApiUrl.civilDefensePredefinedConditions,
      );

      final predefinedConditionsData = predefinedConditionsResponse.data;
      predefinedConditionsData.toString().successLog();

      final predefinedConditionsResult =
          ResponseBodyModel.fromMap(predefinedConditionsData).data?.result;

      predefinedConditionsResult.map<String>((e) => e as String).toList();

      final response = await webService.dio.get(
        '${ApiUrl.civilDefense}/${params.key}',
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      final namesList = result.map((e) => e['name'] as String).toList();

      return [...predefinedConditionsResult, ...namesList];
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<CleaningEntity>> getCleaningMechanisms(
      KeyParamsModel params) async {
    try {
      final response = await webService.dio
          .get('${ApiUrl.cleaningMechanisms}/${params.key}');

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<CleaningEntity>(
            (e) => CleaningModel.fromMap(e as Map<String, dynamic>),
          )
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<CommercialOfficeEntity>> getCommercialOffices(
      KeyParamsModel params) async {
    try {
      final response =
          await webService.dio.get('${ApiUrl.commercialOffices}/${params.key}');

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<CommercialOfficeEntity>(
              (e) => CommercialOfficeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<bool> saveConsultationProgress(
    SaveConsultationProgressParamsModel params,
  ) async {
    try {
      final response = await webService.dio.post(
        '${ApiUrl.saveConsultationProgress}/${params.consultationKey}',
        data: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      ResponseBodyModel.fromMap(data).data?.result;

      return true;
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<bool> saveActivities(SaveActivitiesParamsModel params) async {
    try {
      final response = await webService.dio.post(
        '${ApiUrl.saveActivities}/${params.consultationKey}',
        data: params.activitiesIds,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result;
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<int>> getLicenseYears(GetLicenseYearsParamsModel params) async {
    try {
      final response = await webService.dio.get(
        ApiUrl.licenseYears,
        queryParameters: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result.map<int>((e) => e as int).toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      if (ex is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr());
      }
    }
  }

  @override
  Future<List<BoardTypeEntity>> getBoardTypes() async {
    try {
      final response = await webService.dio.get(ApiUrl.boardTypes);

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<BoardTypeEntity>(
              (e) => BoardTypeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<LicenseFeesEntity> calculateLicenseFees(
      CalculateFeesParamsModel params) async {
    try {
      final response = await webService.dio.post(
        "${ApiUrl.calculateFees}/${params.consultationKey}",
        data: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return LicenseFeesModel.fromMap(result as Map<String, dynamic>);
    } on DioError catch (error) {
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
      );
    } catch (ex) {
      "Catched $ex".errorLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }
}
