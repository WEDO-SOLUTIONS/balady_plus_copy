import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;
import '../../objections_exports.dart'
    show RequestTypeEntity, RequestsRepository;

class GetRequestTypes extends UseCase<List<RequestTypeEntity>, NoParams> {
  final RequestsRepository repository;

  GetRequestTypes({required this.repository});

  @override
  Future<Either<Failure, List<RequestTypeEntity>>> call(NoParams params) async {
    return await repository.getRequestTypes();
  }
}
