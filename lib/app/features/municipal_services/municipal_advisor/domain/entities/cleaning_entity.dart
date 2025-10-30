import 'package:equatable/equatable.dart';

class CleaningEntity extends Equatable {
  final String id;
  final String name;

  const CleaningEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
