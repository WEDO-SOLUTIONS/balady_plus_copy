class PostersUploadResponse {
  final int? id;
  final String? name;
  final dynamic allowedFilesExtension;
  final bool? attached;
  final String? attachUrl;
  final dynamic maxSize;
  final String? originFileName;
  final String? key;
  final dynamic customizedAttachUrl;
  final bool? mandatory;

  PostersUploadResponse({
    this.id,
    this.name,
    this.allowedFilesExtension,
    this.attached,
    this.attachUrl,
    this.maxSize,
    this.originFileName,
    this.key,
    this.customizedAttachUrl,
    this.mandatory,
  });

  factory PostersUploadResponse.fromJson(Map<String, dynamic> json) =>
      PostersUploadResponse(
        id: json["id"],
        name: json["name"],
        allowedFilesExtension: json["allowedFilesExtension"],
        attached: json["attached"],
        attachUrl: json["attachUrl"],
        maxSize: json["maxSize"],
        originFileName: json["originFileName"],
        key: json["key"],
        customizedAttachUrl: json["customizedAttachUrl"],
        mandatory: json["mandatory"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "allowedFilesExtension": allowedFilesExtension,
        "attached": attached,
        "attachUrl": attachUrl,
        "maxSize": maxSize,
        "originFileName": originFileName,
        "key": key,
        "customizedAttachUrl": customizedAttachUrl,
        "mandatory": mandatory,
      };
}
