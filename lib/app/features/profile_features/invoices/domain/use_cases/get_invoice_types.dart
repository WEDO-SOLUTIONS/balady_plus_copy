import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show NoParams, UseCase;
import '../../invoices_exports.dart' show InvoiceTypeEntity, InvoicesRepository;

class GetInvoiceTypes extends UseCase<List<InvoiceTypeEntity>, NoParams> {
  final InvoicesRepository repository;

  GetInvoiceTypes({required this.repository});

  @override
  Future<Either<Failure, List<InvoiceTypeEntity>>> call(NoParams params) async {
    return await repository.getInvoiceTypes();
  }
}
