/*import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../renew_commercial_license_exports.dart' show CrRepository;
import '../entities/cr_attachment_request.dart';

class SaveCrAttachment extends UseCase<bool, CrAttachmentRequest> {
  final CrRepository repository;

  SaveCrAttachment({required this.repository});
  @override
  Future<Either<Failure, bool>> call(CrAttachmentRequest params) async {
    return await repository.saveAttachment(params: params);
  }
}
*/