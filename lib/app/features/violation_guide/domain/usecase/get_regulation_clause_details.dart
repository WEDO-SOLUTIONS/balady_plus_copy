import 'package:balady_plus/app/features/objections/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/models/establishment_size_response.dart';
import '../../data/models/regualation_cluses_details.dart';
import '../entites/regulation_clauses_details_params.dart';
import '../repository/violation_repository.dart';

class GetRegulationClauseDetails
    extends UseCase<RegulationClauseDetails, RegulationClauseDetailsParams> {
  final ViolationGuideRepository repository;
  GetRegulationClauseDetails({required this.repository});
  @override
  Future<Either<Failure, RegulationClauseDetails>> call(
      RegulationClauseDetailsParams params) async {
    return await repository.getRegulationDetails(params);
  }
}
