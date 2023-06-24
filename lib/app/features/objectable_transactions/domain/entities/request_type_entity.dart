import 'package:equatable/equatable.dart';

class RequestTypeEntity extends Equatable {
  final String? id;
  final String? name;

  const RequestTypeEntity({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
