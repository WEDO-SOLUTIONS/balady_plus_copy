class VolunteerLookup {
  final String tid;
  final String name;
  final String? type;
  final int? parentId;
  final bool? status;
  final int? numberOfServices;

  VolunteerLookup({
    required this.tid,
    required this.name,
    this.type,
    this.parentId,
    this.status,
    this.numberOfServices,
  });

  String get text => name;

  factory VolunteerLookup.fromJson(Map<String, dynamic> json) => VolunteerLookup(
        tid: json['tid'].toString(),
        name: json['name'] as String,
        type: json['type'] as String?,
        parentId: json['parentId'] as int?,
        status: json['status'] as bool?,
        numberOfServices: json['numberOfServices'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'tid': tid,
        'name': name,
        'type': type,
        'parentId': parentId,
        'status': status,
        'numberOfServices': numberOfServices,
      };
}
