import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../invoices_exports.dart'
    show InvoicesRepository, InvoiceEntity, InvoiceDetailsParams;

class GetInvoiceDetails extends UseCase<InvoiceEntity, InvoiceDetailsParams> {
  final InvoicesRepository repository;

  GetInvoiceDetails({required this.repository});

  @override
  Future<Either<Failure, InvoiceEntity>> call(
    InvoiceDetailsParams params,
  ) async {
    return await repository.getInvoiceDetails(params);
  }
}
