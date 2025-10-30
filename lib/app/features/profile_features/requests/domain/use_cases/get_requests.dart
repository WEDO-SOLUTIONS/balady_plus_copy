import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../requests_exports.dart'
    show RequestEntity, RequestsPrams, RequestsRepository;

class GetRequests extends UseCase<List<RequestEntity>, RequestsPrams> {
  final RequestsRepository repository;

  GetRequests({required this.repository});

  @override
  Future<Either<Failure, List<RequestEntity>>> call(
      RequestsPrams params) async {
    return await repository.getRequests(params);
  }
}
