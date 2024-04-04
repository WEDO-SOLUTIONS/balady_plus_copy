import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../data/models/upload_dms_attachment_response.dart';
import '../repositories/repository.dart';

class UploadClauseAttachment
    extends UseCase<UploadDmsAttachmentResponse, (FileDataItem, int)> {
  final CreateComplianceRepository repository;
  UploadClauseAttachment({required this.repository});
  @override
  Future<Either<Failure, UploadDmsAttachmentResponse>> call(
      (FileDataItem, int) params) async {
    return await repository.uploadClauseAttachment(params.$1, params.$2);
  }
}
