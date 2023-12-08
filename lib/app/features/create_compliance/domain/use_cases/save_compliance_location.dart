import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../data/models/save_location_compliance_request.dart';
import '../repositories/repository.dart';

class SaveLocationCompliance
    extends UseCase<bool, SaveLocationComplianceRequest> {
  final CreateComplianceRepository repository;
  SaveLocationCompliance({required this.repository});
  @override
  Future<Either<Failure, bool>> call(
      SaveLocationComplianceRequest params) async {
    return await repository.saveLocationCompliance(params);
  }
}
