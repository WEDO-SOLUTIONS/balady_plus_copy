import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../violations_exports.dart';

class GetViolations extends UseCase<List<ViolationsEntity>, ViolationsPrams> {
  final ViolationsRepository repository;

  GetViolations({required this.repository});

  @override
  Future<Either<Failure, List<ViolationsEntity>>> call(
      ViolationsPrams params) async {
    return await repository.getViolations(params);
  }
}
