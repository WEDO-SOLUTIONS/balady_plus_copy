import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show UseCase, NoParams;
import '../../municipal_advisor_exports.dart'
    show BoardTypeEntity, MunicipalAdvisorRepository;

class GetBoardTypes extends UseCase<List<BoardTypeEntity>, NoParams> {
  final MunicipalAdvisorRepository repository;

  GetBoardTypes(this.repository);

  @override
  Future<Either<Failure, List<BoardTypeEntity>>> call(NoParams params) async {
    return await repository.getBoardTypes();
  }
}
