import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart' show MunicipalAdvisorRepository;
import '../entities/building_compliance_entity.dart';

class GetBuildingCompliance
    extends UseCase<List<BuildingComplianceEntity>, GISParams> {
  final MunicipalAdvisorRepository repository;

  GetBuildingCompliance(this.repository);

  @override
  Future<Either<Failure, List<BuildingComplianceEntity>>> call(
      GISParams params) async {
    return await repository.getBuildingCompliance(params);
  }
}
