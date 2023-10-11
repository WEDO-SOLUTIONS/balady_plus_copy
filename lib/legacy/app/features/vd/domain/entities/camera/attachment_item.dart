import 'package:equatable/equatable.dart';

class AttachmentItem extends Equatable {
  int? index;
  String? base64;
  String? filePath;
  String? fileId;
  String? caseId;
  String? categoryId;

  AttachmentItem(
      {this.base64,
      this.filePath,
      this.fileId,
      this.index,
      this.caseId,
      this.categoryId});

  @override
  List<Object?> get props => [index, fileId, filePath, caseId, categoryId];
}
