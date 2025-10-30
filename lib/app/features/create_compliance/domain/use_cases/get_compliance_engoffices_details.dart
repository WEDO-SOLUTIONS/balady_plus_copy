import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;
import '../entities/compliance_engoffice_details.dart';
import '../repositories/repository.dart';

class GetComplianceEngOfficesDetails
    extends UseCase<ComplianceEngOfficeDetails, String> {
  final CreateComplianceRepository repository;
  GetComplianceEngOfficesDetails({required this.repository});
  @override
  Future<Either<Failure, ComplianceEngOfficeDetails>> call(
      String params) async {
    return await repository.getComplianceEngOfficeDetails(id: params);
  }
}
