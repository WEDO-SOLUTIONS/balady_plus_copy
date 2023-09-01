import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../entities/comliance_request_details.dart';
import '../repositories/repository.dart';

class GetComplianceByRequestId
    extends UseCase<ComplianceRequestDetails, String> {
  final CreateComplianceRepository repository;
  GetComplianceByRequestId({required this.repository});
  @override
  Future<Either<Failure, ComplianceRequestDetails>> call(String params) async {
    return await repository.getComplianceByRequestId(params);
  }
}
