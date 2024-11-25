import 'submit_commercial_response_model.dart';

class SaveWorkTimesRequestModel {
  final int? requestId;
  final List<WorkingTime>? workingTimes;

  SaveWorkTimesRequestModel({
    this.requestId,
    this.workingTimes,
  });

  factory SaveWorkTimesRequestModel.fromJson(Map<String, dynamic> json) =>
      SaveWorkTimesRequestModel(
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
