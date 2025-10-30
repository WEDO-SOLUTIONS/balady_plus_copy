import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart' show CrRepository;
import '../entities/cr_attachment_request.dart';

class SaveCrAttachment extends UseCase<bool, CrAttachmentRequest> {
  final CrRepository repository;

  SaveCrAttachment({required this.repository});
  @override
  Future<Either<Failure, bool>> call(CrAttachmentRequest params) async {
    return await repository.saveAttachment(params: params);
  }
}
