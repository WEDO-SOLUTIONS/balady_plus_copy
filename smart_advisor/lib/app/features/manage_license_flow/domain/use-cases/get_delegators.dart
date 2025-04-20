import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../entities/delegator_entity.dart';
import '../repositories/repository.dart';

class GetDelegators implements UseCase<List<DelegatorEntity>, NoParams> {
  final ManageLicenseRepository repository;

  GetDelegators(this.repository);

  @override
  Future<Either<Failure, List<DelegatorEntity>>> call(NoParams params) async {
    return await repository.getDelegators();
  }
}
