import 'package:balady_plus/app/features/objections/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/models/attachment_resposne_model.dart';
import '../../data/models/posters_upload_response_model.dart';
import '../entities/save_poster_request_params.dart';
import '../repositores/repository.dart';

class UploadPosterFile
    extends UseCase<PostersUploadResponse, PermitAttachmentItem> {
  final PostersRepository repository;
  UploadPosterFile({required this.repository});
  @override
  Future<Either<Failure, PostersUploadResponse>> call(
      PermitAttachmentItem params) async {
    return await repository.uploadPosterFile(params: params);
  }
}
