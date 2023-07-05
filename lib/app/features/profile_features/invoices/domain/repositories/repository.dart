import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../invoices_exports.dart'
    show
        InvoiceEntity,
        InvoiceStatusEntity,
        InvoiceSubTypeEntity,
        InvoiceSubTypeParamsModel,
        InvoiceTypeEntity,
        InvoiceDetailsParamsModel,
        InvoicesPrams;

abstract class InvoicesRepository {
  Future<Either<Failure, List<InvoiceEntity>>> getInvoices(
    InvoicesPrams params,
  );
  Future<Either<Failure, List<InvoiceStatusEntity>>> getInvoiceStatuses();
  Future<Either<Failure, List<InvoiceTypeEntity>>> getInvoiceTypes();
  Future<Either<Failure, List<InvoiceSubTypeEntity>>> getInvoiceSubTypes(
    InvoiceSubTypeParamsModel params,
  );
  Future<Either<Failure, InvoiceEntity>> getInvoiceDetails(
    InvoiceDetailsParamsModel params,
  );
}
