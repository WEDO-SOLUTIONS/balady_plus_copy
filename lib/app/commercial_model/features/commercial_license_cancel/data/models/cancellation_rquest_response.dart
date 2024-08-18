import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/data/models/reason_cancel.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/reason_cancel.dart';

class CancellationRequestResponse {
  int requestId;
  // List<ReasonCancel> cancellationReasons;
  bool availableCloseDate;
  dynamic warningInfo;

  CancellationRequestResponse({
    required this.requestId,
    // required this.cancellationReasons,
    required this.availableCloseDate,
    required this.warningInfo,
  });

  factory CancellationRequestResponse.fromJson(Map<String, dynamic> json) =>
      CancellationRequestResponse(
        requestId: json["requestId"],
        // cancellationReasons: List<ReasonCancel>.from(json["cancellationReasons"].map((x) => ReasonCancel.fromJson(x))),
        availableCloseDate: json["availableCloseDate"],
        warningInfo: json["warningInfo"],
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        // "cancellationReasons": List<dynamic>.from(cancellationReasons.map((x) => x.toJson())),
        "availableCloseDate": availableCloseDate,
        "warningInfo": warningInfo,
      };
}
