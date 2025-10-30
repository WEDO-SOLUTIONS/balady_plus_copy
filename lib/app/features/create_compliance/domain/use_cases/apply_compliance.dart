import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../data/models/apply_create_compliance_request_model.dart';
import '../entities/apply_create_compliance_response.dart';
import '../repositories/repository.dart';

class ApplyCompliance extends UseCase<ApplyCreateComplianceResponse,
    ApplyCreateComplianceRequest> {
  final CreateComplianceRepository repository;
  ApplyCompliance({required this.repository});
  @override
  Future<Either<Failure, ApplyCreateComplianceResponse>> call(
      ApplyCreateComplianceRequest params) async {
    return await repository.applyCreateCompliance(params);
  }
}
