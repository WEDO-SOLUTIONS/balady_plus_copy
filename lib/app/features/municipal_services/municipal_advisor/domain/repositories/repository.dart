import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../municipal_advisor_exports.dart'
    show
        ActivityDetailsEntity,
        ActivityDetailsParamsModel,
        ConsultationKeyParamsModel,
        IsicActivityEntity,
        IsicSubActivityParamsModel;

abstract class MunicipalAdvisorRepository {
  Future<Either<Failure, List<IsicActivityEntity>>> getIsicActivities();
  Future<Either<Failure, List<IsicActivityEntity>>> getIsicSubActivities(
      IsicSubActivityParamsModel params);
  Future<Either<Failure, ActivityDetailsEntity>> getActivityDetails(
      ActivityDetailsParamsModel params);

  Future<Either<Failure, String>> getConsultationKey(
      ConsultationKeyParamsModel params);
}
