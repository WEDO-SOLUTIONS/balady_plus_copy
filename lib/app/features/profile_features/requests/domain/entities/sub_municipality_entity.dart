import 'package:equatable/equatable.dart';

class SubMunicipalityEntity extends Equatable {
  final String id;
  final String name;

  const SubMunicipalityEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
