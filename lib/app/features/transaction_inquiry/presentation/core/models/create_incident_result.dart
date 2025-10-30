import 'error_result.dart';

class CreateIncidentResult {
  String? pyId;
  String? pzInsKey;
  String? caseDeadline;
  String? assignmentKey;
  String? amanaIncidentID;
  List<ErrorResult>? errors;

  CreateIncidentResult({
    this.pyId,
    this.pzInsKey,
    this.caseDeadline,
    this.assignmentKey,
    this.amanaIncidentID,
    this.errors,
  });

  factory CreateIncidentResult.fromJson(Map<String, dynamic> json) =>
      CreateIncidentResult(
        pyId: json["pyID"],
        pzInsKey: json["pzInsKey"],
        caseDeadline: json["CaseDeadline"],
        assignmentKey: json["AssignmentKey"],
        amanaIncidentID: json["AmanaIncidentID"],
        errors: json["errors"] != null
            ? List<ErrorResult>.from(
                json["errors"].map((x) => ErrorResult.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "pyID": pyId,
        "pzInsKey": pzInsKey,
        "CaseDeadline": caseDeadline,
        "AssignmentKey": assignmentKey,
        "AmanaIncidentID": amanaIncidentID,
        "errors": List<ErrorResult>.from(errors!.map((x) => x)),
      };
}
