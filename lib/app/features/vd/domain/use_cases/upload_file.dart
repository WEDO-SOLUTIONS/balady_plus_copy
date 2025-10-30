import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show VDRepository, UploadFileResponse, UploadFileParams, SPLDetailsResponse;
import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;
import 'package:balady_plus/app/core/services/services_exports.dart'
    show UseCase;

import 'package:dartz/dartz.dart' show Either;

class UploadFile extends UseCase<UploadFileResponse, UploadFileParams> {
  final VDRepository repository;

  UploadFile({required this.repository});
  @override
  Future<Either<Failure, UploadFileResponse>> call(
      UploadFileParams params) async {
    String fileName = params.filePath?.split('/').last ?? "";
    String memo = fileName;
    int extensionIndex = fileName.lastIndexOf(".");
    if (extensionIndex != -1 && extensionIndex != 0) {
      memo = fileName.substring(0, extensionIndex);
    }
    params = params.copyWith(
        category: "Initial", pxAttachName: fileName, pyMemo: memo);
    return await repository.uploadFile(params: params);
  }
}
