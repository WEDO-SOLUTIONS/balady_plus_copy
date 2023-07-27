import 'error_result.dart';

class INQClassificationResponse {
  List<ClassificationItem>? data;
  List<ErrorResult>? errors;

  INQClassificationResponse({
    this.data,
    this.errors,
  });

  factory INQClassificationResponse.fromJson(dynamic json) =>
      INQClassificationResponse(
        data: json != null
            ? List<ClassificationItem>.from(
                json.map((x) => ClassificationItem.fromMap(x)))
            : null,
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
