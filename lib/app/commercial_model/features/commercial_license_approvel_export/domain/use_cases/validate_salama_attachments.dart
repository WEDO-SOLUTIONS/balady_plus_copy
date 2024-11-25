import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';

class ValidateSalamaAttachments
    extends UseCase<int, ValidateSalamaAttachmentsRequest> {
  final CrRepository repository;

  ValidateSalamaAttachments({required this.repository});
  @override
  Future<Either<Failure, int>> call(
      ValidateSalamaAttachmentsRequest params) async {
    return await repository.validateSalamaAttachments(params: params);
  }
}
