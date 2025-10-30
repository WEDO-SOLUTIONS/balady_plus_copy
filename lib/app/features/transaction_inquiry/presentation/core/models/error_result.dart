class ErrorResult {
  String? id;
  String? message;
  String? fieldName;
  String? pyID;

  ErrorResult({this.id, this.message, this.fieldName, this.pyID});

  factory ErrorResult.fromJson(Map<String, dynamic> json) => ErrorResult(
      id: json["ID"],
      message: json["message"],
      fieldName: json["FieldName"],
      pyID: json["pyID"]);

  Map<String, dynamic> toJson() =>
      {"ID": id, "message": message, "FieldName": fieldName, "pyID": pyID};
}
