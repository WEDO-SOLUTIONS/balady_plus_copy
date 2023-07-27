import 'package:equatable/equatable.dart';

class BoardTypeEntity extends Equatable {
  final int id;
  final String name;

  const BoardTypeEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
