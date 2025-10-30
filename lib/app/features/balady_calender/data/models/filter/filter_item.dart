import 'package:equatable/equatable.dart';

class FilterItem extends Equatable {
  final String? id;
  final String? name;

  const FilterItem({this.id, this.name});

  factory FilterItem.fromJson(Map<String, dynamic> json) => FilterItem(
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
