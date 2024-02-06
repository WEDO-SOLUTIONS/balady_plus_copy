import 'package:equatable/equatable.dart';

class Type extends Equatable {
  final String? id;
  final String? name;

  const Type({this.id, this.name});

  factory Type.fromJson(Map<String, dynamic> json) => Type(
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
