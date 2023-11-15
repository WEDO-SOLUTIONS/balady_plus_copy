// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class QrLookUpResponse {
  final List<QrLookUpItem>? result;

  QrLookUpResponse({
    this.result,
  });

  factory QrLookUpResponse.fromJson(Map<String, dynamic> json) =>
      QrLookUpResponse(
        result: json["result"] == null
            ? []
            : List<QrLookUpItem>.from(
                json["result"]!.map((x) => QrLookUpItem.fromJson(x))),
      );
}

class QrLookUpItem extends Equatable {
  final int? id;
  final String? name;
  final dynamic ename;
  bool? selected;

  QrLookUpItem({this.id, this.name, this.ename, this.selected});

  factory QrLookUpItem.fromJson(Map<String, dynamic> json) => QrLookUpItem(
        id: json["id"],
        name: json["name"],
        ename: json["ename"],
      );

  @override
  List<Object?> get props => [id, name];

  String get text => name ?? "";
}
