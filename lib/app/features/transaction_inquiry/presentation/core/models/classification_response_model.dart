import 'error_result.dart';

class ClassificationResponse {
  List<ClassificationItem> data;
  List<ErrorResult>? errors;

  ClassificationResponse({
    required this.data,
    this.errors,
  });

  factory ClassificationResponse.fromJson(dynamic json) =>
      ClassificationResponse(
        data: List<ClassificationItem>.from(
            json.map((x) => ClassificationItem.fromMap(x))),
        //  errors: json["errors"]!=null ? List<ErrorResult>.from(json["errors"].map((x) =>  ErrorResult.fromJson(x))):[]
      );
}

class ClassificationItem {
  String? id;
  String? name;

  ClassificationItem({
    this.id,
    this.name,
  });

  factory ClassificationItem.fromMap(Map<String, dynamic> map) =>
      ClassificationItem(
        id: map["ID"],
        name: map["Name"],
      );

  Map<String, dynamic> toMap() => {
        "ID": id,
        "Name": name,
      };
}
