import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show MunicipalAdvisorRepository, SaveConsultationProgressParams;

class SaveConsultationProgress
    extends UseCase<bool, SaveConsultationProgressParams> {
  final MunicipalAdvisorRepository repository;

  SaveConsultationProgress(this.repository);

  @override
  Future<Either<Failure, bool>> call(
    SaveConsultationProgressParams params,
  ) async {
    return await repository.saveConsultationProgress(params);
  }
}
