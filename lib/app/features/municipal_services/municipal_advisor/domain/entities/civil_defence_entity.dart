import 'package:equatable/equatable.dart';

class CivilDefenceEntity extends Equatable {
  final String id;
  final String name;

  const CivilDefenceEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
