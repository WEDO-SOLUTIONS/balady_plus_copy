import 'dart:convert';

import '../../../transaction_inquiry/presentation/core/models/error_result.dart';

DaemCreateTicket daemCreateTicketFromJson(String str) =>
    DaemCreateTicket.fromJson(json.decode(str));

String daemCreateTicketToJson(DaemCreateTicket data) =>
    json.encode(data.toJson());

class DaemCreateTicket {
  DaemCreateTicket({this.incidentId, this.tSRNo, this.errors});

  String? incidentId;
  String? tSRNo;
  List<ErrorResult>? errors;

  factory DaemCreateTicket.fromJson(Map<String, dynamic> json) =>
      DaemCreateTicket(
        incidentId: json["IncidentID"],
        tSRNo: json["TSRNo"],
        errors: json["errors"] != null
            ? List<ErrorResult>.from(
                json["errors"].map((x) => ErrorResult.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "IncidentID": incidentId,
        "TSRNo": tSRNo,
        "errors": List<dynamic>.from(errors!.map((x) => x)),
      };
}
