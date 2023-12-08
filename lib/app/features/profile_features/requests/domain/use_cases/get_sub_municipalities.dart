import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../requests_exports.dart'
    show RequestsRepository, RequestSubTypeEntity, RequestSubTypeParams;

class GetRequestSubTypes
    extends UseCase<List<RequestSubTypeEntity>, RequestSubTypeParams> {
  final RequestsRepository repository;

  GetRequestSubTypes({required this.repository});

  @override
  Future<Either<Failure, List<RequestSubTypeEntity>>> call(
      RequestSubTypeParams params) async {
    return await repository.getRequestSubTypes(params);
  }
}
