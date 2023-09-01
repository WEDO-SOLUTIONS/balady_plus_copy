import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;
import '../entities/complinace_engoffice_response.dart';
import '../repositories/repository.dart';

class GetComplianceEngOffices
    extends UseCase<ComplinaecEngOfficeReponse, NoParams> {
  final CreateComplianceRepository repository;
  GetComplianceEngOffices({required this.repository});
  @override
  Future<Either<Failure, ComplinaecEngOfficeReponse>> call(
      NoParams params) async {
    return await repository.getComplianceEngOffices();
  }
}
