import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../invoices_exports.dart'
    show InvoiceEntity, InvoicesPrams, InvoicesRepository;

class GetInvoices extends UseCase<List<InvoiceEntity>, InvoicesPrams> {
  final InvoicesRepository repository;

  GetInvoices({required this.repository});

  @override
  Future<Either<Failure, List<InvoiceEntity>>> call(
      InvoicesPrams params) async {
    return await repository.getInvoices(params);
  }
}
