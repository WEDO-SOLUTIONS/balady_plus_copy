import 'package:equatable/equatable.dart';

class RequestStatusEntity extends Equatable {
  final int id;
  final String name;

  const RequestStatusEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
