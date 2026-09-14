import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;

import '../../entry_point_exports.dart';

class GetPaymentUrl extends UseCase<String, PaymentRequest> {
  final EntryPointRepository repository;

  GetPaymentUrl({required this.repository});
  @override
  Future<Either<Failure, String>> call(PaymentRequest params) async {
    return await repository.getPaymentURL(params);
  }
}
