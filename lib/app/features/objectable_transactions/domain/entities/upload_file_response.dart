class UploadFileResponse {
  String? id;
  String? AttachmentUrl;
  int? index;
  UploadFileResponse({this.id, this.AttachmentUrl, this.index});
  Map<String, dynamic> toJson() => {"id": id, "AttachmentUrl": AttachmentUrl};

  factory UploadFileResponse.fromJson(Map<String, dynamic> json) {
    return UploadFileResponse(
        id: json["Id"], AttachmentUrl: json["AttachmentUrl"]);
  }
}
