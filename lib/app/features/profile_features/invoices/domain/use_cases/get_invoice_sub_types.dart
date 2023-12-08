import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../invoices_exports.dart'
    show InvoicesRepository, InvoiceSubTypeEntity, InvoiceSubTypeParams;

class GetInvoiceSubTypes
    extends UseCase<List<InvoiceSubTypeEntity>, InvoiceSubTypeParams> {
  final InvoicesRepository repository;

  GetInvoiceSubTypes({required this.repository});

  @override
  Future<Either<Failure, List<InvoiceSubTypeEntity>>> call(
      InvoiceSubTypeParams params) async {
    return await repository.getInvoiceSubTypes(params);
  }
}
