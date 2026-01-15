import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart'
    show UseCase, NoParams;
import '../../delegators_exports.dart'
    show DelegatorEntity, DelegatorsRepository;

class GetDelegators implements UseCase<List<DelegatorEntity>, NoParams> {
  final DelegatorsRepository repository;

  GetDelegators(this.repository);

  @override
  Future<Either<Failure, List<DelegatorEntity>>> call(NoParams params) async {
    return await repository.getDelegators();
  }
}
