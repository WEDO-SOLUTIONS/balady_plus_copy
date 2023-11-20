class AttachmentResponseModel {
  final List<PermitAttachmentItem>? result;

  AttachmentResponseModel({
    this.result,
  });

  factory AttachmentResponseModel.fromJson(Map<String, dynamic> json) =>
      AttachmentResponseModel(
        result: json["result"] == null
            ? []
            : List<PermitAttachmentItem>.from(
                json["result"]!.map((x) => PermitAttachmentItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class PermitAttachmentItem {
  final int? id;
  final String? name;
  final String? allowedFilesExtension;
  final int? maxSize;
  final bool? mandatory;

  PermitAttachmentItem({
    this.id,
    this.name,
    this.allowedFilesExtension,
    this.maxSize,
    this.mandatory,
  });

  factory PermitAttachmentItem.fromJson(Map<String, dynamic> json) =>
      PermitAttachmentItem(
        id: json["id"],
        name: json["name"],
        allowedFilesExtension: json["allowedFilesExtension"],
        maxSize: json["maxSize"],
        mandatory: json["mandatory"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "allowedFilesExtension": allowedFilesExtension,
        "maxSize": maxSize,
        "mandatory": mandatory,
      };
}
