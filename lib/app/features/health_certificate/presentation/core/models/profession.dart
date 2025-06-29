class Profession {
  final String? id;
  final String? name;

  Profession({
    this.id,
    this.name,

  });

  factory Profession.fromJson(Map<String, dynamic> json) {
    return Profession(
      id: json['id']?.toString(),
      name: json['name'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,

    };
  }

  @override
  String toString() => 'Profession(id: $id, name: $name)';
}
