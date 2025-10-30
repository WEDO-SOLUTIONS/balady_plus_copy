import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../violations_exports.dart'
    show
        InvoiceStatusesEntity,
        ViolationDetailsEntity,
        ViolationsEntity,
        ViolationsPrams,
        ViolationsStatusEntity;
import '../entities/violation_details_params.dart';

abstract class ViolationsRepository {
  Future<Either<Failure, List<ViolationsEntity>>> getViolations(
    ViolationsPrams params,
  );
  Future<Either<Failure, List<ViolationsStatusEntity>>> getViolationsStatus();
  Future<Either<Failure, List<InvoiceStatusesEntity>>> getInvoiceStatuses();

  Future<Either<Failure, ViolationDetailsEntity>> getViolationDetails(
      ViolationDetailsParams params);
}
