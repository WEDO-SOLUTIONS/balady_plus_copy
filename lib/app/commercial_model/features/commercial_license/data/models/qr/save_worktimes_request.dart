import 'apply_commercial_response_model.dart';

class SaveWorkTimesRequest {
  final int? requestId;
  final List<WorkingTime>? workingTimes;

  SaveWorkTimesRequest({
    this.requestId,
    this.workingTimes,
  });

  factory SaveWorkTimesRequest.fromJson(Map<String, dynamic> json) =>
      SaveWorkTimesRequest(
        workingTimes: json["workingTimes"] == null
            ? []
            : List<WorkingTime>.from(
                json["workingTimes"]!.map((x) => WorkingTime.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "workingTimes": workingTimes == null
            ? []
            : List<dynamic>.from(workingTimes!.map((x) => x.toJson())),
      };
}
