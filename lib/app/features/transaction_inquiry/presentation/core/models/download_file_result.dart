import 'package:equatable/equatable.dart';

import 'error_result.dart';

class DownloadFileResult extends Equatable {
  String attachmentStream;
  String caseId;
  String attachName;
  List<ErrorResult> errors;
  String? id;

  DownloadFileResult(
      {required this.attachmentStream,
      required this.caseId,
      required this.attachName,
      required this.errors,
      this.id});

  factory DownloadFileResult.fromJson(Map<String, dynamic> json) =>
      DownloadFileResult(
        attachmentStream: json["AttachmentStream"],
        caseId: json["CaseID"],
        attachName: json["AttachName"],
        errors: json["errors"] != null
            ? List<ErrorResult>.from(
                json["errors"].map((x) => ErrorResult.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "AttachmentStream": attachmentStream,
        "CaseID": caseId,
        "AttachName": attachName,
        "errors": List<ErrorResult>.from(errors.map((x) => x)),
      };

  @override
  List<Object?> get props => [id];
}
