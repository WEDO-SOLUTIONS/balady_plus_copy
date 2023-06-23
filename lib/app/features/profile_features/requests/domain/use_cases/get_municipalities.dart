import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show NoParams, UseCase;
import '../../requests_exports.dart'
    show MunicipalityEntity, RequestsRepository;

class GetMunicipalities extends UseCase<List<MunicipalityEntity>, NoParams> {
  final RequestsRepository repository;

  GetMunicipalities({required this.repository});

  @override
  Future<Either<Failure, List<MunicipalityEntity>>> call(
      NoParams params) async {
    return await repository.getMunicipalities();
  }
}
