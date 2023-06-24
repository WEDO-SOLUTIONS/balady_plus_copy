import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;

import '../../objections_exports.dart';
import '../entities/transaction_details.dart';
import '../entities/transaction_details_params.dart';

class GetTransactionDetails
    extends UseCase<TransactionDetails, TransactionDetailsParams> {
  final RequestsRepository repository;
  GetTransactionDetails({required this.repository});
  @override
  Future<Either<Failure, TransactionDetails>> call(
      TransactionDetailsParams params) async {
    return await repository.getTransactionDetails(params);
  }
}
