import 'package:balady_plus/app/features/municipal_services/municipal_advisor/data/models/save_consultation_progress_params_model.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../data/models/building_compliance_model.dart';
import '../../municipal_advisor_exports.dart'
    show
        AccommodationTypeEntity,
        ActivityDetailsEntity,
        ActivityDetailsParamsModel,
        AdditionalActivitiesParamsModel,
        AttachmentEntity,
        AttachmentParamsModel,
        BoardTypeEntity,
        CalculateFeesParamsModel,
        CleaningEntity,
        CommercialOfficeEntity,
        ConditionsUrlsEntity,
        ContractEntity,
        EngineeringOfficeEntity,
        FastflowConditionEntity,
        FinancialStudyParamsModel,
        GetLicenseYearsParamsModel,
        InteractiveInfoParamsModel,
        IsicActivityEntity,
        IsicSubActivityParamsModel,
        KeyParamsModel,
        LicenseFeesEntity,
        LicensePermitEntity,
        RequestStepModel,
        SaveActivitiesParamsModel,
        SupervisingAuthorityEntity,
        UpdatePermitParamsModel;
import '../entities/building_compliance_entity.dart';
import '../entities/civil_defence_entity.dart';
import '../entities/validate_additional_activities_params.dart';

abstract class MunicipalAdvisorRepository {
  Future<Either<Failure, List<IsicActivityEntity>>> getIsicActivities();
  Future<Either<Failure, List<IsicActivityEntity>>> getIsicSubActivities(
    IsicSubActivityParamsModel params,
  );
  Future<Either<Failure, List<ActivityDetailsEntity>>> getAdditionalActivities(
    ActivityDetailsParamsModel params,
  );
  Future<Either<Failure, ActivityDetailsEntity>> getActivityDetails(
    ActivityDetailsParamsModel params,
  );
  Future<Either<Failure, List<AccommodationTypeEntity>>>
      getAccommodationTypes();
  Future<Either<Failure, (String, int)>> getConsultationKey();
  Future<Either<Failure, bool>> saveAdditionalActivities(
    AdditionalActivitiesParamsModel params,
  );

  Future<Either<Failure, bool>> validateAdditionalActivities(
    ValidateAdditionalActivitiesParams params,
  );

  Future<Either<Failure, List<String>>> getIssuingPredefinedConditions();
  Future<Either<Failure, List<LicensePermitEntity>>> getLicensePermits(
    KeyParamsModel params,
  );
  Future<Either<Failure, List<SupervisingAuthorityEntity>>>
      getSupervisingAuthorities(
    KeyParamsModel params,
  );
  Future<Either<Failure, List<String>>> getCivilDefensePredefinedConditions(
    KeyParamsModel params,
  );
  Future<Either<Failure, List<CivilDefenceEntity>>> getCivilDefenseConditions(
    KeyParamsModel params,
  );
  Future<Either<Failure, List<CleaningEntity>>> getCleaningMechanisms(
    KeyParamsModel params,
  );
  Future<Either<Failure, List<CommercialOfficeEntity>>> getCommercialOffices(
    KeyParamsModel params,
  );
  Future<Either<Failure, List<EngineeringOfficeEntity>>> getEngineeringOffices(
    KeyParamsModel params,
  );
  Future<Either<Failure, bool>> saveConsultationProgress(
    SaveConsultationProgressParamsModel params,
  );
  Future<Either<Failure, bool>> saveActivities(
    SaveActivitiesParamsModel params,
  );
  Future<Either<Failure, List<int>>> getLicenseYears(
    GetLicenseYearsParamsModel params,
  );
  Future<Either<Failure, List<BoardTypeEntity>>> getBoardTypes();
  Future<Either<Failure, LicenseFeesEntity>> calculateLicenseFees(
    CalculateFeesParamsModel params,
  );
  Future<Either<Failure, bool>> saveFinancialStudy(
    FinancialStudyParamsModel params,
  );
  Future<Either<Failure, List<ContractEntity>>> getShopOwnership(
    KeyParamsModel params,
  );
  Future<Either<Failure, List<AttachmentEntity>>> getConsultationAttachments(
    AttachmentParamsModel params,
  );
  Future<Either<Failure, bool>> saveInteractiveInfo(
    InteractiveInfoParamsModel params,
  );
  Future<Either<Failure, int>> getMaxLicenseYears(
    KeyParamsModel params,
  );
  Future<Either<Failure, ConditionsUrlsEntity>> getConditionsUrls();
  Future<Either<Failure, List<FastflowConditionEntity>>> getFastflowConditions(
    KeyParamsModel params,
  );
  Future<Either<Failure, List<RequestStepModel>>> getRequestFlow(
    KeyParamsModel params,
  );
  Future<Either<Failure, List<String>>> getRequestFlowRecommendations(
    KeyParamsModel params,
  );
  Future<Either<Failure, LicensePermitEntity>> updatePermit(
    UpdatePermitParamsModel params,
  );
  Future<Either<Failure, bool>> submitConsultation(
    KeyParamsModel params,
  );

  Future<Either<Failure, List<BuildingComplianceEntity>>> getBuildingCompliance(
    GISParams params,
  );

  Future<Either<Failure, String>> getGISImage(
    GISParams params,
  );
}
