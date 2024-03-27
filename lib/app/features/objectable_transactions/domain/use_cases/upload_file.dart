import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../objections_exports.dart';

class UploadFile extends UseCase<UploadFileResponse, AttachmentItem> {
  final RequestsRepository repository;

  UploadFile({required this.repository});

  @override
  Future<Either<Failure, UploadFileResponse>> call(AttachmentItem item) async {
    UploadFileParams params = UploadFileParams(
        attachStream: item.base64, filePath: item.filePath, index: item.index);
    String fileName = params.filePath?.split('/').last ?? "";
    String memo = fileName;
    // fileName = fileName.replaceAll("أ", "ا");
    ;
    int extensionIndex = fileName.lastIndexOf(".");
    if (extensionIndex != -1 && extensionIndex != 0) {
      memo = fileName.substring(0, extensionIndex);
    }
    params = params.copyWith(
        category: item.categoryId,
        caseId: item.caseId,
        pxAttachName: fileName,
        pyMemo: memo);
    return await repository.uploadFile(params: params);
  }
}
