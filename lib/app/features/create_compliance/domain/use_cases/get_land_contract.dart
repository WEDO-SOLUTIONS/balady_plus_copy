import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;
import '../entities/land_subsidy_contract.dart';
import '../entities/land_subsidy_contract_request.dart';
import '../repositories/repository.dart';

class GetLandContract
    extends UseCase<LandSubsidyContract, LandSubsidyContractRequest> {
  final CreateComplianceRepository repository;
  GetLandContract({required this.repository});
  @override
  Future<Either<Failure, LandSubsidyContract>> call(
      LandSubsidyContractRequest params) async {
    return await repository.getLandContract(params);
  }
}
