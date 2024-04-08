class Regions {
  final String code;
  final String text;

  Regions({
    required this.code,
    required this.text,
  });

  factory Regions.fromMap(Map<String, dynamic> json) {
    return Regions(
      code: json["code"] ?? '',
      text: json["name"] ?? '',
    );
  }

  @override
  String toString() => text;
}
