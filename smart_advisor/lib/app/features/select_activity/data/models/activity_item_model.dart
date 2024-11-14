class ActivityCount {
  final int id;
  final String name;
  final int count;

  ActivityCount({
    required this.id,
    required this.name,
    required this.count,
  });

  // Factory constructor to create an instance from JSON
  factory ActivityCount.fromJson(Map<String, dynamic> json) {
    return ActivityCount(
      id: json['ISIC_NUMBER'] ?? json['D_ACTIVITIES_ID'] ?? json['Category_ID'],
      name: json['ISIC_DESC'] ??
          json['D_ACTIVITIES_NAME'] ??
          json["Category_name"],
      count: json['count'],
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'count': count,
    };
  }
}
