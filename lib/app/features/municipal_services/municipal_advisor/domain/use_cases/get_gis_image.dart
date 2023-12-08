import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../../../vd/domain/entities/gis/gis_params.dart';
import '../../municipal_advisor_exports.dart' show MunicipalAdvisorRepository;

class GetGISImage extends UseCase<String, GISParams> {
  final MunicipalAdvisorRepository repository;

  GetGISImage(this.repository);

  @override
  Future<Either<Failure, String>> call(GISParams params) async {
    return await repository.getGISImage(params);
  }
}
