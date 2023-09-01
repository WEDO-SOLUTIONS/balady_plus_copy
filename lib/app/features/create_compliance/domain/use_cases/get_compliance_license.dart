import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;
import '../../data/models/ownership_doc_type_response_model.dart';
import '../entities/complinace_licenses_response.dart';
import '../entities/ownership_doc_type_response.dart';
import '../repositories/repository.dart';

class GetComplianceLicenses
    extends UseCase<ComplinaecLicensesReponse, NoParams> {
  final CreateComplianceRepository repository;
  GetComplianceLicenses({required this.repository});
  @override
  Future<Either<Failure, ComplinaecLicensesReponse>> call(
      NoParams params) async {
    return await repository.getComplianceLicense();
  }
}
