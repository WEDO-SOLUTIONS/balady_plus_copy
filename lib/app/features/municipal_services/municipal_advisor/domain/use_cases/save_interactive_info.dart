import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show InteractiveInfoParams, MunicipalAdvisorRepository;

class SaveInteractiveInfo extends UseCase<bool, InteractiveInfoParams> {
  final MunicipalAdvisorRepository repository;

  SaveInteractiveInfo(this.repository);

  @override
  Future<Either<Failure, bool>> call(
    InteractiveInfoParams params,
  ) async {
    return await repository.saveInteractiveInfo(params);
  }
}
