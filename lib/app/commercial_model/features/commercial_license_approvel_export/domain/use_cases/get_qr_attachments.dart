import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/attachment_response_entity.dart';

class GetQrAttachments extends UseCase<AttachmentResponseEntity, int> {
  final CrRepository repository;

  GetQrAttachments({required this.repository});
  @override
  Future<Either<Failure, AttachmentResponseEntity>> call(int params) async {
    return await repository.getQrAttachments(params: params);
  }
}
