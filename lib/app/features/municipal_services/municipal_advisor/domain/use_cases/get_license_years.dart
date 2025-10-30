import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show GetLicenseYearsParams, MunicipalAdvisorRepository;

class GetLicenseYears extends UseCase<List<int>, GetLicenseYearsParams> {
  final MunicipalAdvisorRepository repository;

  GetLicenseYears(this.repository);

  @override
  Future<Either<Failure, List<int>>> call(GetLicenseYearsParams params) async {
    return await repository.getLicenseYears(params);
  }
}
