class VolunteerLookup {
  final String tid;
  final String name;

  VolunteerLookup({
    required this.tid,
    required this.name,
  });

  String get text => name;

  factory VolunteerLookup.fromJson(Map<String, dynamic> json) => VolunteerLookup(
      tid: json['tid'] as String,
      name: json['name'] as String,
    );

  Map<String, dynamic> toJson() => {
      'tid': tid,
      'name': name,
    };
}
