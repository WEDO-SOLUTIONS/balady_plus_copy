import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show NoParams, UseCase;
import '../../municipal_advisor_exports.dart' show MunicipalAdvisorRepository;

class GetConsultationKey extends UseCase<String, NoParams> {
  final MunicipalAdvisorRepository repository;

  GetConsultationKey(this.repository);

  @override
  Future<Either<Failure, String>> call(params) async {
    return await repository.getConsultationKey();
  }
}
