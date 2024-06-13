import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../data/models/compliance_certificate_item_request.dart';
import '../repositories/repository.dart';

class SaveComplianceCertificateItem
    extends UseCase<bool, ComplianceCertificateItemRequest> {
  final CreateComplianceRepository repository;
  SaveComplianceCertificateItem({required this.repository});
  @override
  Future<Either<Failure, bool>> call(
      ComplianceCertificateItemRequest params) async {
    return await repository.saveComplianceCertificateItem(params);
  }
}
