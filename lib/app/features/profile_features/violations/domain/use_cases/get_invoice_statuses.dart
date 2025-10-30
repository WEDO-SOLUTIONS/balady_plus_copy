import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show NoParams, UseCase;
import '../../violations_exports.dart'
    show InvoiceStatusesEntity, ViolationsRepository;

class GetInvoiceStatuses
    extends UseCase<List<InvoiceStatusesEntity>, NoParams> {
  final ViolationsRepository repository;

  GetInvoiceStatuses({required this.repository});

  @override
  Future<Either<Failure, List<InvoiceStatusesEntity>>> call(
      NoParams params) async {
    return await repository.getInvoiceStatuses();
  }
}
