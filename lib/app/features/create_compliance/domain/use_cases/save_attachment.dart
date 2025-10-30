import 'package:balady_plus/app/features/create_compliance/domain/entities/compliance_attachment_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../repositories/repository.dart';

class SaveAttachment extends UseCase<bool, ComplinaceAttachmentRequest> {
  final CreateComplianceRepository repository;
  SaveAttachment({required this.repository});
  @override
  Future<Either<Failure, bool>> call(ComplinaceAttachmentRequest params) async {
    return await repository.saveAttachment(params: params);
  }
}
