import 'package:balady_plus/app/features/create_compliance/domain/entities/compliance_gis_resopnse.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_params.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../repositories/repository.dart';

class GetComplianceGIS extends UseCase<ComplainceGISResponse, GISParams> {
  final CreateComplianceRepository repository;
  GetComplianceGIS({required this.repository});
  @override
  Future<Either<Failure, ComplainceGISResponse>> call(GISParams params) async {
    return await repository.getGISInfo(params: params);
  }
}
