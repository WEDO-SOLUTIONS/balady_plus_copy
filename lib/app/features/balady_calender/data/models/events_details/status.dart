import 'package:equatable/equatable.dart';

class Status extends Equatable {
  final String? id;
  final String? name;

  const Status({this.id, this.name});

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json['id'] as String?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  List<Object?> get props => [id, name];
}
