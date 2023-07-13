import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show CommercialOfficeEntity, KeyParamsModel, MunicipalAdvisorRepository;

class GetCommercialOffices
    extends UseCase<List<CommercialOfficeEntity>, KeyParamsModel> {
  final MunicipalAdvisorRepository repository;

  GetCommercialOffices(this.repository);

  @override
  Future<Either<Failure, List<CommercialOfficeEntity>>> call(
      KeyParamsModel params) async {
    return await repository.getCommercialOffices(params);
  }
}
