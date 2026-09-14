import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class AttachmentItem extends BaseData with Equatable {
  final int? index;
  final String? base64;
  final Uint8List? encodeImage;
  final String? filePath;
  final String? fileId;
  final String? caseId;
  final String? categoryId;

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
