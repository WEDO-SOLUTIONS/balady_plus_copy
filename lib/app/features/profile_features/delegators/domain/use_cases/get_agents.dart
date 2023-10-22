import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show UseCase, NoParams;
import '../../delegators_exports.dart' show AgentEntity, DelegatorsRepository;

class GetAgents implements UseCase<List<AgentEntity>, NoParams> {
  final DelegatorsRepository repository;

  GetAgents(this.repository);

  @override
  Future<Either<Failure, List<AgentEntity>>> call(NoParams params) async {
    return await repository.getAgents();
  }
}
