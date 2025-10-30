import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class AttachmentItem extends Equatable {
  int? index;
  String? base64;
  Uint8List? encodeImage;
  String? filePath;
  String? fileId;
  String? caseId;
  String? categoryId;

  AttachmentItem(
      {this.base64,
      this.filePath,
      this.fileId,
      this.encodeImage,
      this.index,
      this.caseId,
      this.categoryId});

  @override
  List<Object?> get props => [index, fileId, filePath, caseId, categoryId];
}
