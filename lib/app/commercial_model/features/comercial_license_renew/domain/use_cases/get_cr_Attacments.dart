import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../renew_commercial_license_exports.dart' show RenewCrRepository;
import '../entities/cr_attachment_response.dart';

class GetCrAttachments extends UseCase<CrAttachmentResponse, int> {
  final RenewCrRepository repository;

  GetCrAttachments({required this.repository});
  @override
  Future<Either<Failure, CrAttachmentResponse>> call(int params) async {
    return await repository.getCRAttachments(params);
  }
}
