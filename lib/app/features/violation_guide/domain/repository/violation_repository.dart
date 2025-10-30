import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../vd/domain/entities/gis/gis_params.dart';
import '../../data/models/classification_response.dart';
import '../../data/models/establishment_size_response.dart';
import '../../data/models/regualation_cluses_details.dart';
import '../../data/models/regulation_clause_response.dart';
import '../../data/models/violator_response.dart';
import '../entites/regulation_clauses_details_params.dart';
import '../entites/regulation_clauses_params.dart';

abstract class ViolationGuideRepository {
  Future<Either<Failure, RegulationClausesResponse>>
      getRegulationClausesResponse(
    RegulationClausesParams params,
  );
  Future<Either<Failure, EstablishmentSizeResponse>> getEstablishmentSize();
  Future<Either<Failure, ViolationClassificationResponse>>
      getViolationsClassifications(GISParams params);
  Future<Either<Failure, ViolatorResponse>> getViolatorsLookUp();

  Future<Either<Failure, RegulationClauseDetails>> getRegulationDetails(
    RegulationClauseDetailsParams params,
  );
}
