import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;
import '../../objections_exports.dart'
    show RequestStatusEntity, RequestsRepository;

class GetRequestStatuses extends UseCase<List<RequestStatusEntity>, NoParams> {
  final RequestsRepository repository;

  GetRequestStatuses({required this.repository});

  @override
  Future<Either<Failure, List<RequestStatusEntity>>> call(
      NoParams params) async {
    return await repository.getRequestStatuses();
  }
}
