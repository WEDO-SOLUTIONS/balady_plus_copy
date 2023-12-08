import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show NoParams, UseCase;
import '../../invoices_exports.dart'
    show InvoiceStatusEntity, InvoicesRepository;

class GetInvoiceStatuses extends UseCase<List<InvoiceStatusEntity>, NoParams> {
  final InvoicesRepository repository;

  GetInvoiceStatuses({required this.repository});

  @override
  Future<Either<Failure, List<InvoiceStatusEntity>>> call(
      NoParams params) async {
    return await repository.getInvoiceStatuses();
  }
}
