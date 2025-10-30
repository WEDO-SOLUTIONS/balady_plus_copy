import '../../commercial_license_exports.dart' show CredenceInfo, CredenceItem;

class CredenceInfoModel extends CredenceInfo {
  CredenceInfoModel({
    super.manual,
    super.electronic,
  });

  factory CredenceInfoModel.fromJson(Map<String, dynamic> json) =>
      CredenceInfoModel(
        manual: json["manual"] == null
            ? []
            : List<CredenceItemModel>.from(
                json["manual"]!.map((x) => CredenceItemModel.fromJson(x))),
        electronic: json["electronic"] == null
            ? []
            : List<CredenceItemModel>.from(
                json["electronic"]!.map((x) => CredenceItemModel.fromJson(x))),
      );
}

class CredenceItemModel extends CredenceItem {
  CredenceItemModel({
    super.credenceId,
    super.credenceName,
    super.attached,
    super.credenceTypeId,
    super.credenceTypeName,
    super.attachmentUrl,
    super.letterUrl,
    super.approved,
    super.notes,
  });

  factory CredenceItemModel.fromJson(Map<String, dynamic> json) =>
      CredenceItemModel(
        credenceId: json["credenceId"],
        credenceName: json["credenceName"],
        attached: json["attached"],
        credenceTypeId: json["credenceTypeId"],
        credenceTypeName: json["credenceTypeName"],
        attachmentUrl: json["attachmentUrl"],
        letterUrl: json["letterUrl"],
        approved: json["approved"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "credenceId": credenceId,
        "credenceName": credenceName,
        "attached": attached,
        "credenceTypeId": credenceTypeId,
        "credenceTypeName": credenceTypeName,
        "attachmentUrl": attachmentUrl,
        "letterUrl": letterUrl,
        "approved": approved,
        "notes": notes,
      };
}
