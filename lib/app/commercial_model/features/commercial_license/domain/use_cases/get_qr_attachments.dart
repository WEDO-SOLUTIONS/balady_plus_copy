import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/cr_attachment_response_model.dart';

class GetQrAttachments extends UseCase<CrAttachmentResponseModel, int> {
  final CrRepository repository;

  GetQrAttachments({required this.repository});
  @override
  Future<Either<Failure, CrAttachmentResponseModel>> call(int params) async {
    return await repository.getQrAttachments(params: params);
  }
}
