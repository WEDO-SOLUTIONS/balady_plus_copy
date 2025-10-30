import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show ContractEntity, KeyParamsModel, MunicipalAdvisorRepository;

class GetShopOwnership extends UseCase<List<ContractEntity>, KeyParamsModel> {
  final MunicipalAdvisorRepository repository;

  GetShopOwnership(this.repository);

  @override
  Future<Either<Failure, List<ContractEntity>>> call(
      KeyParamsModel params) async {
    return await repository.getShopOwnership(params);
  }
}
