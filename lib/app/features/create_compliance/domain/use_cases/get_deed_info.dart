import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;
import '../entities/compliance_deed_info.dart';
import '../entities/compliance_deed_info_request.dart';
import '../repositories/repository.dart';

class GetDeedInfo
    extends UseCase<ComplianceDeedInfo, ComplianceDeedInfoRequest> {
  final CreateComplianceRepository repository;
  GetDeedInfo({required this.repository});
  @override
  Future<Either<Failure, ComplianceDeedInfo>> call(
      ComplianceDeedInfoRequest params) async {
    return await repository.getDeedInfo(params);
  }
}
