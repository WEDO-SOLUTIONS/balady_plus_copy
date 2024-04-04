class UploadDmsAttachmentResponse {
  final String? fileKey;
  final String? dmsAttachId;
  final String? dmsAttachKey;
  final String? dmsAttachName;
  final String? dmsAttachExtension;
  final String? dmsAttachSize;

  UploadDmsAttachmentResponse({
    this.fileKey,
    this.dmsAttachId,
    this.dmsAttachKey,
    this.dmsAttachName,
    this.dmsAttachExtension,
    this.dmsAttachSize,
  });

  factory UploadDmsAttachmentResponse.fromJson(Map<String, dynamic> json) =>
      UploadDmsAttachmentResponse(
        fileKey: json["fileKey"],
        dmsAttachId: json["dmsAttachId"],
        dmsAttachKey: json["dmsAttachKey"],
        dmsAttachName: json["dmsAttachName"],
        dmsAttachExtension: json["dmsAttachExtension"],
        dmsAttachSize: json["dmsAttachSize"],
      );

  Map<String, dynamic> toJson() => {
        "fileKey": fileKey,
        "dmsAttachId": dmsAttachId,
        "dmsAttachKey": dmsAttachKey,
        "dmsAttachName": dmsAttachName,
        "dmsAttachExtension": dmsAttachExtension,
        "dmsAttachSize": dmsAttachSize,
      };
}
