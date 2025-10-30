import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show UseCase, NoParams;
import '../../municipal_advisor_exports.dart'
    show AccommodationTypeEntity, MunicipalAdvisorRepository;

class GetAccommodationTypes
    extends UseCase<List<AccommodationTypeEntity>, NoParams> {
  final MunicipalAdvisorRepository repository;

  GetAccommodationTypes(this.repository);

  @override
  Future<Either<Failure, List<AccommodationTypeEntity>>> call(
      NoParams params) async {
    return await repository.getAccommodationTypes();
  }
}
