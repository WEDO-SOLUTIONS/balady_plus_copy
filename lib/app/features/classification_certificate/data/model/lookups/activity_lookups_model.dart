
class ActivityLookupsModel  {
  final String activityValue;

  ActivityLookupsModel({
    required this.activityValue,
  });

  ActivityLookupsModel copyWith({
    String? activityValue,
  }) =>
      ActivityLookupsModel(
        activityValue: activityValue ?? this.activityValue,
      );

  factory ActivityLookupsModel.fromJson(Map<String, dynamic> json) => ActivityLookupsModel(
    activityValue: json["activityValue"],
  );

  Map<String, dynamic> toJson() => {
    "activityValue": activityValue,
  };
}

