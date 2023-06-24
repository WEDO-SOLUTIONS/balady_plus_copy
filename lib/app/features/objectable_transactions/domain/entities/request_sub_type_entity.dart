import 'package:equatable/equatable.dart';

class RequestSubTypeEntity extends Equatable {
  final String? id;
  final String? name;

  const RequestSubTypeEntity({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
