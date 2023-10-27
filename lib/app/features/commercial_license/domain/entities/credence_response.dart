import 'package:equatable/equatable.dart';

class CredenceInfo {
  final List<CredenceItem>? manual;
  final List<CredenceItem>? electronic;

  CredenceInfo({
    this.manual,
    this.electronic,
  });
}

class CredenceItem extends Equatable {
  final int? credenceId;
  final String? credenceName;
  final bool? attached;
  final int? credenceTypeId;
  final String? credenceTypeName;
  dynamic attachmentUrl;
  final String? letterUrl;
  final bool? approved;
  final dynamic notes;

  CredenceItem({
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

  factory CredenceItem.fromJson(Map<String, dynamic> json) => CredenceItem(
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

  @override
  List<Object?> get props => [credenceId, credenceTypeId, attachmentUrl];
}
