import '../../data/models/violation_details_vd_model.dart';
import '../entities/violation_details_vd_request_params.dart';
import '/app/features/details/data/models/entity_violation_activity_model.dart';
import '/app/features/details/domain/entities/entity_activity_details_request_params.dart';
import '/app/features/details/domain/entities/entity_activity_details_response.dart';
import '/app/features/details/domain/entities/entity_violation_activity_request_params.dart';
import '/app/features/details/domain/entities/regulation_request_params.dart';
import '/app/features/details/domain/entities/regulation_response.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../data/models/entity_violation_activity_details_model.dart';
import '../entities/entity_violation_activity_details_request_params.dart';

abstract class DetailsRepository {
  Future<Either<Failure, RegulationResponse>> getRegulations(RegulationRequestParams params);

  Future<Either<Failure, EntityActivityDetailsResponse>> getEntityActivity(EntityActivityDetailRequestParams params);

  Future<Either<Failure, List<EntityViolationActivityModel>>> getViolationEntityDetails(
      EntityViolationActivityRequestParams params);

  Future<Either<Failure, EntityViolationActivityDetailsModel>> getEntityViolationActivityDetails(
      EntityViolationActivityDetailsRequestParams params);

  Future<Either<Failure, List<ViolationDetailsVdModel>>> getEntityViolationDetailsVd(
      ViolationDetailsVdRequestParams params);
}
