import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../objections_exports.dart';

class UploadFileV2 extends UseCase<UploadFileResponse, AttachmentItem> {
  final RequestsRepository repository;

  UploadFileV2({required this.repository});

  @override
  Future<Either<Failure, UploadFileResponse>> call(AttachmentItem item) async {
    UploadFileParams params = UploadFileParams(
        attachStream: item.base64, filePath: item.filePath, index: item.index);
    String fileName = params.filePath?.split('/').last ?? "";

    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    String newFileName = fileName.replaceRange(0, fileName.lastIndexOf("."), "$timeStamp");
    String memo = newFileName;
    int extensionIndex = newFileName.lastIndexOf(".");
    if (extensionIndex != -1 && extensionIndex != 0) {
      memo = newFileName.substring(0, extensionIndex);
    }
    params = params.copyWith(
        category: item.categoryId,
        caseId: item.caseId,
        pxAttachName: newFileName,
        pyMemo: memo);
    return await repository.uploadFileV2(params: params);
  }
}
