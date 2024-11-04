class Age {
  dynamic year;
  dynamic month;
  dynamic day;
  dynamic description;

  Age({this.year, this.month, this.day, this.description});

  factory Age.fromJson(Map<String, dynamic> json) => Age(
        year: json['year'] as dynamic,
        month: json['month'] as dynamic,
        day: json['day'] as dynamic,
        description: json['description'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'year': year,
        'month': month,
        'day': day,
        'description': description,
      };
}
