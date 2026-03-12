import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class AttachmentItem extends BaseData with EquatableMixin {
  int? index;
  String? base64;
  Uint8List? encodeImage;
  String? filePath;
  String? fileId;
  String? caseId;
  String? categoryId;

  AttachmentItem({this.base64, this.filePath, this.fileId, this.encodeImage, this.index, this.caseId, this.categoryId});

  @override
  List<Object?> get props => [index, fileId, filePath, caseId, categoryId];

  @override
  toJson() {
    return {
      "index": index,
      "base64": base64,
      "filePath": filePath,
      "fileId": fileId,
      "encodeImage": encodeImage,
      "caseId": caseId,
      "categoryId": categoryId,
    };
  }
}
