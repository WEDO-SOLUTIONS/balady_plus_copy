import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../data/models/apply_create_compliance_request_model.dart';
import '../../data/models/save_location_compliance_request.dart';
import '../entities/apply_create_compliance_response.dart';
import '../entities/comliance_request_details.dart';

abstract class CreateComplianceRepository {
  Future<Either<Failure, ApplyCreateComplianceResponse>> applyCreateCompliance(
    ApplyCreateComplianceRequest params,
  );

  Future<Either<Failure, ComplianceRequestDetails>> getComplianceByRequestId(
    String params,
  );

  Future<Either<Failure, bool>> saveLocationCompliance(
    SaveLocationComplianceRequest params,
  );
}
