import 'package:balady_plus/app/features/objections/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/models/regulation_clause_response.dart';
import '../entites/regulation_clauses_params.dart';
import '../repository/violation_repository.dart';

class GetRegulationClause
    extends UseCase<RegulationClausesResponse, RegulationClausesParams> {
  final ViolationGuideRepository repository;
  GetRegulationClause({required this.repository});
  @override
  Future<Either<Failure, RegulationClausesResponse>> call(
      RegulationClausesParams params) async {
    return await repository.getRegulationClausesResponse(params);
  }
}
