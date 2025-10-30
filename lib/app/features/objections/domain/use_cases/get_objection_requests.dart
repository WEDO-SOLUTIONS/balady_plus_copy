import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../objections_exports.dart'
    show ObjectionEntity, ObjectionsRequestsPrams, RequestsRepository;

class GetObjectionRequests
    extends UseCase<List<ObjectionEntity>, ObjectionsRequestsPrams> {
  final RequestsRepository repository;

  GetObjectionRequests({required this.repository});

  @override
  Future<Either<Failure, List<ObjectionEntity>>> call(
      ObjectionsRequestsPrams params) async {
    return await repository.getObjectionRequests(params);
  }
}
