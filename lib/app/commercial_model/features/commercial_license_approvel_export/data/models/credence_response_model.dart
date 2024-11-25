import 'package:equatable/equatable.dart';


class CredenceResponseModel{
  final List<CredenceItemModel>? manual;
  final List<CredenceItemModel>? electronic;

  CredenceResponseModel({
    this.manual,
    this.electronic,
  });

  factory CredenceResponseModel.fromJson(Map<String, dynamic> json) =>
      CredenceResponseModel(
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

class CredenceItemModel extends Equatable{
  final int? credenceId;
  final String? credenceName;
  final bool? attached;
  final int? credenceTypeId;
  final String? credenceTypeName;
  dynamic attachmentUrl;
  final String? letterUrl;
  final bool? approved;
  final dynamic notes;

  CredenceItemModel({
    this.credenceId,
    this.credenceName,
    this.attached,
    this.credenceTypeId,
    this.credenceTypeName,
    this.attachmentUrl,
    this.letterUrl,
    this.approved,
    this.notes,
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

  @override
  List<Object?> get props => [credenceId, credenceTypeId, attachmentUrl];
}
