import 'package:equatable/equatable.dart';

class RequestSubTypeEntity extends Equatable {
  final int id;
  final String name;

  const RequestSubTypeEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
