import 'error_result.dart';

class UploadFileResult {
  String? linkedRefFrom;
  String? linkedRefTo;
  List<ErrorResult>? errors;

  UploadFileResult({
    this.linkedRefFrom,
    this.linkedRefTo,
    this.errors,
  });

  factory UploadFileResult.fromJson(Map<String, dynamic> json) =>
      UploadFileResult(
        linkedRefFrom: json["LinkedRefFrom"],
        linkedRefTo: json["LinkedRefTo"],
        errors: json["errors"] != null
            ? List<ErrorResult>.from(
                json["errors"].map((x) => ErrorResult.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "LinkedRefFrom": linkedRefFrom,
        "LinkedRefTo": linkedRefTo,
        "errors": List<ErrorResult>.from(errors!.map((x) => x)),
      };
}
