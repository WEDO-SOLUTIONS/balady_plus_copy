class GeneralConditionsModel {
  final String? type;
  final String? name;
  final String? letter;
  final List<String>? points;

  GeneralConditionsModel({
    this.type,
    this.name,
    this.letter,
    this.points,
  });

  GeneralConditionsModel copyWith({
    String? type,
    String? name,
    String? letter,
    List<String>? points,
  }) =>
      GeneralConditionsModel(
        type: type ?? this.type,
        name: name ?? this.name,
        letter: letter ?? this.letter,
        points: points ?? this.points,
      );

  factory GeneralConditionsModel.fromJson(Map<String, dynamic> json) =>
      GeneralConditionsModel(
        type: json["type"],
        name: json["name"],
        letter: json["letter"],
        points: json["points"] == null
            ? []
            : List<String>.from(json["points"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "name": name,
        "letter": letter,
        "points":
            points == null ? [] : List<dynamic>.from(points!.map((x) => x)),
      };
}
