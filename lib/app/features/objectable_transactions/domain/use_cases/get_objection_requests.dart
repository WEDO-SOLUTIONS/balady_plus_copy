import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../objections_exports.dart'
    show
        ObjectableTransactionsEntity,
        TransactionsRequestsPrams,
        RequestsRepository;

class GetObjectionRequests extends UseCase<List<ObjectableTransactionsEntity>,
    TransactionsRequestsPrams> {
  final RequestsRepository repository;

  GetObjectionRequests({required this.repository});

  @override
  Future<Either<Failure, List<ObjectableTransactionsEntity>>> call(
      TransactionsRequestsPrams params) async {
    return await repository.getObjectionRequests(params);
  }
}
