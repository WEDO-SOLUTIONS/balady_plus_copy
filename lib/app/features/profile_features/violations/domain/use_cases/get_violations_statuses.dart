import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show NoParams, UseCase;
import '../../violations_exports.dart'
    show ViolationsStatusEntity, ViolationsRepository;

class GetViolationsStatuses
    extends UseCase<List<ViolationsStatusEntity>, NoParams> {
  final ViolationsRepository repository;

  GetViolationsStatuses({required this.repository});

  @override
  Future<Either<Failure, List<ViolationsStatusEntity>>> call(
      NoParams params) async {
    return await repository.getViolationsStatus();
  }
}
