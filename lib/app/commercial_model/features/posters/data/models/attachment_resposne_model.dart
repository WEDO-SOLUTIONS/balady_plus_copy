// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  String? fileName;
  String? filePath;
  int? requestId;
  String? base64;
  String? key;
  int? posterTypeId;
  int? posterId;

  PermitAttachmentItem(
      {this.id,
      this.name,
      this.allowedFilesExtension,
      this.maxSize,
      this.mandatory,
      this.fileName,
      this.filePath,
      this.requestId,
      this.base64,
      this.key,
      this.posterTypeId,
      this.posterId});

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

  PermitAttachmentItem copyWith(
      {int? id,
      String? name,
      String? allowedFilesExtension,
      int? maxSize,
      bool? mandatory,
      String? fileName,
      String? filePath,
      int? requestId,
      String? base64,
      String? key,
      int? posterTypeId,
      int? posterId}) {
    return PermitAttachmentItem(
        id: id ?? this.id,
        name: name ?? this.name,
        allowedFilesExtension:
            allowedFilesExtension ?? this.allowedFilesExtension,
        maxSize: maxSize ?? this.maxSize,
        mandatory: mandatory ?? this.mandatory,
        fileName: fileName ?? this.fileName,
        filePath: filePath ?? this.filePath,
        requestId: requestId ?? this.requestId,
        base64: base64 ?? this.base64,
        key: key ?? this.key,
        posterTypeId: posterTypeId ?? this.posterTypeId,
        posterId: posterId ?? this.posterId);
  }
}
