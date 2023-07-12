import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show ConsultationKeyParams, MunicipalAdvisorRepository;

class GetConsultationKey extends UseCase<String, ConsultationKeyParams> {
  final MunicipalAdvisorRepository repository;

  GetConsultationKey(this.repository);

  @override
  Future<Either<Failure, String>> call(ConsultationKeyParams params) async {
    return await repository.getConsultationKey(params);
  }
}
