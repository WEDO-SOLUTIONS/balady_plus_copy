import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../invoices_exports.dart'
    show InvoiceDetailsEntity, InvoiceDetailsParams, InvoicesRepository;

class GetInvoiceDetails
    extends UseCase<InvoiceDetailsEntity, InvoiceDetailsParams> {
  final InvoicesRepository repository;

  GetInvoiceDetails({required this.repository});

  @override
  Future<Either<Failure, InvoiceDetailsEntity>> call(
    InvoiceDetailsParams params,
  ) async {
    return await repository.getInvoiceDetails(params);
  }
}
