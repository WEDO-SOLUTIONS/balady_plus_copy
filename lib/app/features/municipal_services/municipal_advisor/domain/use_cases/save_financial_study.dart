import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show FinancialStudyParams, MunicipalAdvisorRepository;

class SaveFinancialStudy extends UseCase<bool, FinancialStudyParams> {
  final MunicipalAdvisorRepository repository;

  SaveFinancialStudy(this.repository);

  @override
  Future<Either<Failure, bool>> call(
    FinancialStudyParams params,
  ) async {
    return await repository.saveFinancialStudy(params);
  }
}
