import 'dart:typed_data';

class AttachmentItemModel {
  String? attachmentUuid;
  String? attachmentFileName;
  String? attachmentPath;
  Uint8List? attachmentBase64;
  bool? updatable;

  AttachmentItemModel(
      {this.attachmentBase64,
      this.attachmentFileName,
      this.attachmentPath,
      this.attachmentUuid,
      this.updatable});
}
