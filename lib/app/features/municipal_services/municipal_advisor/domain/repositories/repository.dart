import 'package:balady_plus/app/features/municipal_services/municipal_advisor/data/models/save_consultation_progress_params_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../municipal_advisor_exports.dart'
    show AccommodationTypeEntity, ActivityDetailsEntity, ActivityDetailsParamsModel, CommercialOfficeEntity, ConsultationKeyParamsModel, IsicActivityEntity, IsicSubActivityParamsModel, KeyParamsModel, LicensePermitEntity, SupervisingAuthorityEntity;

abstract class MunicipalAdvisorRepository {
  Future<Either<Failure, List<IsicActivityEntity>>> getIsicActivities();
  Future<Either<Failure, List<IsicActivityEntity>>> getIsicSubActivities(
    IsicSubActivityParamsModel params,
  );
  Future<Either<Failure, ActivityDetailsEntity>> getActivityDetails(
    ActivityDetailsParamsModel params,
  );
  Future<Either<Failure, List<AccommodationTypeEntity>>> getAccommodationTypes();
  Future<Either<Failure, String>> getConsultationKey(
    ConsultationKeyParamsModel params,
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
  Future<Either<Failure, List<String>>> getCleaningMechanisms(
    KeyParamsModel params,
  );
  Future<Either<Failure, List<CommercialOfficeEntity>>> getCommercialOffices(
    KeyParamsModel params,
  );
  Future<Either<Failure, bool>> saveConsultationProgress(
    SaveConsultationProgressParamsModel params,
  );
}
