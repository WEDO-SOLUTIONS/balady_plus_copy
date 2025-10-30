import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../data/models/compliance_certificate_items_request.dart';
import '../repositories/repository.dart';

class SaveComplianceCertificateItems
    extends UseCase<bool, ComplianceCertificateItemsRequest> {
  final CreateComplianceRepository repository;
  SaveComplianceCertificateItems({required this.repository});
  @override
  Future<Either<Failure, bool>> call(
      ComplianceCertificateItemsRequest params) async {
    return await repository.saveComplianceCertificateItems(params);
  }
}
