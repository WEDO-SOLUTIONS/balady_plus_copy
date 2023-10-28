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

class WorkingTime {
  final int? dayId;
  final String? dayName;
  final String? firstFromTime;
  final String? firstToTime;
  final String? openShiftOption;
  final String? secondFromTime;
  final String? secondToTime;

  WorkingTime({
    this.dayId,
    this.dayName,
    this.firstFromTime,
    this.firstToTime,
    this.openShiftOption,
    this.secondFromTime,
    this.secondToTime,
  });

  factory WorkingTime.fromJson(Map<String, dynamic> json) => WorkingTime(
        dayId: json["dayId"],
        dayName: json["dayName"],
        firstFromTime: json["firstFromTime"],
        firstToTime: json["firstToTime"],
        openShiftOption: json["openShiftOption"],
        secondFromTime: json["secondFromTime"],
        secondToTime: json["secondToTime"],
      );

  Map<String, dynamic> toJson() => {
        "dayId": dayId,
        "dayName": dayName,
        "firstFromTime": firstFromTime,
        "firstToTime": firstToTime,
        "openShiftOption": openShiftOption,
        "secondFromTime": secondFromTime,
        "secondToTime": secondToTime,
      };
}
