import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../vd/domain/entities/upload/upload_file_params.dart';
import '../../../vd/domain/entities/upload/upload_file_response.dart';
import '../../../vd/domain/repositories/vd_repository.dart';

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
