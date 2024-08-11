import 'package:balady_plus/app/core/utils/constants/apis/api_headers.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/municipal_services/municipal_advisor/data/models/building_compliance_model.dart';
import 'package:balady_plus/app/features/municipal_services/municipal_advisor/data/models/civil_defence_model.dart';
import 'package:balady_plus/app/features/municipal_services/municipal_advisor/domain/entities/validate_additional_activities_params.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:dio/dio.dart' show DioError, Options;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

import '../../../../../../etmam_app/core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/errors_exports.dart'
    show APIException, NoDataFoundException, ServerException;
import '../../../../../core/services/services_exports.dart' show WebService;
import '../../../../../core/utils/utils_exports.dart'
    show ApiUrl, CommonProperties, Log;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ResponseBodyModel;
import '../../municipal_advisor_exports.dart'
    show
        AccommodationTypeEntity,
        AccommodationTypeModel,
        ActivityDetailsModel,
        ActivityDetailsParamsModel,
        AdditionalActivitiesParamsModel,
        AttachmentEntity,
        AttachmentModel,
        AttachmentParamsModel,
        BoardTypeEntity,
        BoardTypeModel,
        CalculateFeesParamsModel,
        CleaningEntity,
        CleaningModel,
        CommercialOfficeEntity,
        CommercialOfficeModel,
        ConditionsUrlsEntity,
        ConditionsUrlsModel,
        ContractEntity,
        ContractModel,
        EngineeringOfficeEntity,
        EngineeringOfficeModel,
        FastflowConditionEntity,
        FastflowConditionModel,
        FinancialStudyParamsModel,
        GetLicenseYearsParamsModel,
        InteractiveInfoParamsModel,
        IsicActivityModel,
        IsicSubActivityParamsModel,
        KeyParamsModel,
        LicenseFeesEntity,
        LicenseFeesModel,
        LicensePermitEntity,
        LicensePermitModel,
        RequestStepModel,
        SaveActivitiesParamsModel,
        SaveConsultationProgressParamsModel,
        SupervisingAuthorityEntity,
        SupervisingAuthorityModel,
        UpdatePermitParamsModel;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class MunicipalAdvisorRemoteDataSource {
  Future<List<IsicActivityModel>> getIsicActivities();
  Future<List<IsicActivityModel>> getIsicSubActivities(
    IsicSubActivityParamsModel params,
  );
  Future<List<ActivityDetailsModel>> getAdditionalActivities(
    ActivityDetailsParamsModel params,
  );
  Future<ActivityDetailsModel> getActivityDetails(
    ActivityDetailsParamsModel params,
  );
  Future<List<AccommodationTypeEntity>> getAccommodationTypes();
  Future<(String, int)> getConsultationKey();
  Future<bool> saveAdditionalActivities(
    AdditionalActivitiesParamsModel params,
  );
  Future<List<String>> getIssuingPredefinedConditions();
  Future<List<LicensePermitEntity>> getLicensePermits(KeyParamsModel params);
  Future<List<SupervisingAuthorityEntity>> getSupervisingAuthorities(
    KeyParamsModel params,
  );
  Future<List<String>> getCivilDefensePredefinedConditions(
    KeyParamsModel params,
  );

  Future<List<CivilDefenceModel>> getCivilDefenseConditions(
    KeyParamsModel params,
  );

  Future<List<CleaningEntity>> getCleaningMechanisms(
    KeyParamsModel params,
  );
  Future<List<CommercialOfficeEntity>> getCommercialOffices(
    KeyParamsModel params,
  );
  Future<List<EngineeringOfficeEntity>> getEngineeringOffices(
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
  Future<bool> saveFinancialStudy(
    FinancialStudyParamsModel params,
  );
  Future<List<ContractEntity>> getShopOwnership(
    KeyParamsModel params,
  );
  Future<List<AttachmentEntity>> getConsultationAttachments(
    AttachmentParamsModel params,
  );
  Future<bool> saveInteractiveInfo(
    InteractiveInfoParamsModel params,
  );
  Future<int> getMaxLicenseYears(
    KeyParamsModel params,
  );
  Future<ConditionsUrlsEntity> getConditionsUrls();
  Future<List<FastflowConditionEntity>> getFastflowConditions(
    KeyParamsModel params,
  );
  Future<List<RequestStepModel>> getRequestFlow(
    KeyParamsModel params,
  );
  Future<List<String>> getRequestFlowRecommendations(
    KeyParamsModel params,
  );
  Future<LicensePermitEntity> updatePermit(
    UpdatePermitParamsModel params,
  );
  Future<bool> submitConsultation(
    KeyParamsModel params,
  );

  Future<List<BuildingComplianceModel>> getBuildingCompliance(GISParams params);

  Future<String> getImageUrl(GISParams params);

  Future<bool> validateAdditionalActivities(
      ValidateAdditionalActivitiesParams params);
}

class MunicipalAdvisorRemoteDataSourceImplementation
    implements MunicipalAdvisorRemoteDataSource {
  final WebService webService;

  MunicipalAdvisorRemoteDataSourceImplementation({required this.webService});

  @override
  Future<List<IsicActivityModel>> getIsicActivities() async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.isicActivities,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<IsicActivityModel>(
              (e) => IsicActivityModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<IsicActivityModel>> getIsicSubActivities(
      IsicSubActivityParamsModel params) async {
    var response;
    try {
      response = await webService.dio.get(
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
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ActivityDetailsModel> getActivityDetails(
      ActivityDetailsParamsModel params) async {
    var response;
    try {
      response = await webService.dio.get(
        "${ApiUrl.activityDetails}/${params.id}",
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return ActivityDetailsModel.fromMap(result as Map<String, dynamic>);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<AccommodationTypeEntity>> getAccommodationTypes() async {
    var response;
    try {
      response = await webService.dio.get(
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
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<(String, int)> getConsultationKey() async {
    var response;
    try {
      response = await webService.dio.post(ApiUrl.consultationKey);

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return (result['uniqueKey'] as String, result['id'] as int);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<String>> getIssuingPredefinedConditions() async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.issuingPredefinedConditions,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result.map<String>((e) => e as String).toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<LicensePermitEntity>> getLicensePermits(
      KeyParamsModel params) async {
    var response;
    try {
      response =
          await webService.dio.get('${ApiUrl.licensePermits}/${params.key}');

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<LicensePermitEntity>(
              (e) => LicensePermitModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<SupervisingAuthorityEntity>> getSupervisingAuthorities(
      KeyParamsModel params) async {
    var response;
    try {
      response = await webService.dio
          .get('${ApiUrl.supervisingAuthorities}/${params.key}');

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<SupervisingAuthorityEntity>((e) =>
              SupervisingAuthorityModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<String>> getCivilDefensePredefinedConditions(
    KeyParamsModel params,
  ) async {
    var response;
    try {
      final predefinedConditionsResponse = await webService.dio.get(
        ApiUrl.civilDefensePredefinedConditions,
      );

      final predefinedConditionsData = predefinedConditionsResponse.data;
      predefinedConditionsData.toString().successLog();

      final predefinedConditionsResult =
          ResponseBodyModel.fromMap(predefinedConditionsData).data?.result;

      predefinedConditionsResult.map<String>((e) => e as String).toList();

      return [
        ...predefinedConditionsResult,
      ];
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<CleaningEntity>> getCleaningMechanisms(
      KeyParamsModel params) async {
    var response;
    try {
      response = await webService.dio
          .get('${ApiUrl.cleaningMechanisms}/${params.key}');

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<CleaningEntity>(
            (e) => CleaningModel.fromMap(e as Map<String, dynamic>),
          )
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<CommercialOfficeEntity>> getCommercialOffices(
      KeyParamsModel params) async {
    var response;
    try {
      response =
          await webService.dio.get('${ApiUrl.commercialOffices}/${params.key}');

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<CommercialOfficeEntity>(
              (e) => CommercialOfficeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<EngineeringOfficeEntity>> getEngineeringOffices(
      KeyParamsModel params) async {
    var response;
    try {
      response = await webService.dio
          .get('${ApiUrl.engineeringOffices}/${params.key}');

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<EngineeringOfficeEntity>(
              (e) => EngineeringOfficeModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<bool> saveConsultationProgress(
    SaveConsultationProgressParamsModel params,
  ) async {
    var response;
    try {
      response = await webService.dio.post(
        '${ApiUrl.saveConsultationProgress}/${params.consultationKey}',
        data: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      ResponseBodyModel.fromMap(data).data?.result;

      return true;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return false;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<bool> saveActivities(SaveActivitiesParamsModel params) async {
    var response;
    try {
      response = await webService.dio.post(
          '${ApiUrl.saveActivities}/${params.consultationKey}',
          data: params.activitiesIds.toList(),
          options: Options(headers: {"Content-Type": "application/json"}));

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return false;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<List<int>> getLicenseYears(GetLicenseYearsParamsModel params) async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.licenseYears,
        queryParameters: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result.map<int>((e) => e as int).toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
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
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
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
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<List<AttachmentEntity>> getConsultationAttachments(
      AttachmentParamsModel params) async {
    try {
      final response = await webService.dio.get(
        "${ApiUrl.consultationAttachments}/${params.consultationKey}",
        queryParameters: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<AttachmentEntity>(
              (e) => AttachmentModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<bool> saveInteractiveInfo(InteractiveInfoParamsModel params) async {
    try {
      final response = await webService.dio.post(
        "${ApiUrl.interactiveInfo}/${params.consultationKey}",
        data: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      ResponseBodyModel.fromMap(data).data?.result;

      return true;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<List<ContractEntity>> getShopOwnership(KeyParamsModel params) async {
    try {
      final response = await webService.dio.get(
        ApiUrl.shopOwnership,
        queryParameters: {
          'consultationId': params.key,
        },
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<ContractEntity>(
              (e) => ContractModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<bool> saveFinancialStudy(FinancialStudyParamsModel params) async {
    var response;
    try {
      response = await webService.dio.post(
        "${ApiUrl.saveFinancialStudy}/${params.consultationKey}",
        data: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      ResponseBodyModel.fromMap(data).data;

      return true;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return false;
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ConditionsUrlsEntity> getConditionsUrls() async {
    try {
      final response = await webService.dio.get(
        ApiUrl.conditionsUrls,
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return ConditionsUrlsModel.fromMap(result as Map<String, dynamic>);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<List<FastflowConditionEntity>> getFastflowConditions(
    KeyParamsModel params,
  ) async {
    try {
      final response = await webService.dio.get(
        '${ApiUrl.fastflowConditions}/${params.key}',
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<FastflowConditionEntity>(
              (e) => FastflowConditionModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".successLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<int> getMaxLicenseYears(
    KeyParamsModel params,
  ) async {
    try {
      final response = await webService.dio.get(
        '${ApiUrl.maxLicenseYears}/${params.key}',
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return result as int;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".successLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<List<RequestStepModel>> getRequestFlow(KeyParamsModel params) async {
    try {
      final response = await webService.dio.get(
        '${ApiUrl.requestFlow}/${params.key}',
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<RequestStepModel>(
              (e) => RequestStepModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".successLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<List<String>> getRequestFlowRecommendations(
      KeyParamsModel params) async {
    try {
      final response = await webService.dio.get(
        '${ApiUrl.requestFlowRecommendations}/${params.key}',
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return result.map<String>((e) => e as String).toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".successLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<LicensePermitEntity> updatePermit(
      UpdatePermitParamsModel params) async {
    try {
      final response = await webService.dio.get(
        '${ApiUrl.updatePermit}/${params.consultationKey}',
        queryParameters: params.toMap(),
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return LicensePermitModel.fromMap(result as Map<String, dynamic>);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".successLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<List<ActivityDetailsModel>> getAdditionalActivities(
      ActivityDetailsParamsModel params) async {
    try {
      final response = await webService.dio.get(
        '${ApiUrl.additionalActivities}/${params.id}',
      );

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;
      return result
          .map<ActivityDetailsModel>(
              (e) => ActivityDetailsModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".successLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<bool> saveAdditionalActivities(
      AdditionalActivitiesParamsModel params) async {
    try {
      final response = await webService.dio
          .post('${ApiUrl.additionalActivity}/${params.consultationKey}',
              data: {
                "additionalActivities": params.ids
                    .map((e) => {"activityId": e.$1, "area": e.$2})
                    .toList(),
                "hasSalamaPermit": params.hasSalamaPermit,
                "mainActivityArea": params.mainActivityArea,
                "shopArea": params.shopArea

              },
              options: Options(headers: {"Content-Type": "application/json"}));

      final data = response.data;
      data.toString().successLog();

      ResponseBodyModel.fromMap(data).data;

      return true;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      /* if (error is NoDataFoundException) {
        return false;
      }*/

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".successLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<bool> submitConsultation(KeyParamsModel params) async {
    try {
      final response = await webService.dio.post(
        '${ApiUrl.submitConsultation}/${params.key}',
      );

      final data = response.data;
      data.toString().successLog();

      ResponseBodyModel.fromMap(data).data;

      return true;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".successLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<List<BuildingComplianceModel>> getBuildingCompliance(
      GISParams params) async {
    try {
      final response = await webService.dio.get(ApiUrl.buildingCompliance,
          queryParameters: params.toMap(),
          options: Options(headers: {
            ApiHeader.requiresToken.eName: false,
          }));

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<BuildingComplianceModel>((e) =>
              BuildingComplianceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      var errorCode;
      try {
        final result = ResponseBodyModel.fromMap(error.response?.data).data;
        errorCode = result?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        errorCode: errorCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<String> getImageUrl(GISParams params) async {
    try {
      final response = await webService.dio.get(ApiUrl.gisImageUrl,
          queryParameters: params.toMap(),
          options: Options(headers: {
            ApiHeader.requiresToken.eName: false,
          }));

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result["ImageURL"];
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

      var errorCode;
      try {
        final result = ResponseBodyModel.fromMap(error.response?.data).data;
        errorCode = result?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        errorCode: errorCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }

  @override
  Future<List<CivilDefenceModel>> getCivilDefenseConditions(
      KeyParamsModel params) async {
    var response;
    try {
      response = await webService.dio
          .post('${ApiUrl.civilDefense}/${params.key}', data: {
        "civilDefenseActivityRequestDtoList":
            params.civilDefenseActivityRequestDtoList?.map((e) {
                  return {"activityId": e.$1, "area": e.$2};
                }).toList() ??
                []
      });

      final data = response.data;
      data.toString().successLog();

      final result = ResponseBodyModel.fromMap(data).data?.result;

      return result
          .map<CivilDefenceModel>(
              (e) => CivilDefenceModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();
      if (error is NoDataFoundException) {
        return [];
      }
      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".errorLog();
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<bool> validateAdditionalActivities(
      ValidateAdditionalActivitiesParams params) async {
    try {
      final response = await webService.dio
          .post(ApiUrl.validActivitiesAreasUrl, data: params.toMap());

      final data = response.data;
      data.toString().successLog();

      ResponseBodyModel.fromMap(data).data;

      return true;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "DioError $error".errorLog();

      throw ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      "Catched $error".successLog();
      throw ServerException("errors_server_error_2".tr());
    }
  }
}
