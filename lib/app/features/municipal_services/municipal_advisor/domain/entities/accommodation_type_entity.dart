import 'package:equatable/equatable.dart';

class AccommodationTypeEntity extends Equatable {
  final int id;
  final String name;

  const AccommodationTypeEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
