import 'package:equatable/equatable.dart';

class ViolationsStatusEntity extends Equatable {
  final int id;
  final String name;

  const ViolationsStatusEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
