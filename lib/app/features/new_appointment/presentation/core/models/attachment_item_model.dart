import 'dart:typed_data';

class AttachmentItemModel {
  int? attachmentId;
  String? attachmentUuid;
  String? attachmentFileName;
  String? attachmentPath;
  Uint8List? attachmentBase64;
  bool? updatable;

  AttachmentItemModel(

      {
       this.attachmentId,
        this.attachmentBase64,
      this.attachmentFileName,
      this.attachmentPath,
      this.attachmentUuid,
      this.updatable});
}
