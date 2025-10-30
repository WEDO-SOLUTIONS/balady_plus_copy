import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../requests_exports.dart'
    show RequestsRepository, SubMunicipalityEntity, SubMunicipalityParams;

class GetSubMunicipalities
    extends UseCase<List<SubMunicipalityEntity>, SubMunicipalityParams> {
  final RequestsRepository repository;

  GetSubMunicipalities({required this.repository});

  @override
  Future<Either<Failure, List<SubMunicipalityEntity>>> call(
      SubMunicipalityParams params) async {
    return await repository.getSubMunicipalities(params);
  }
}
