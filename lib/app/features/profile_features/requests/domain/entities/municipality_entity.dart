import 'package:equatable/equatable.dart';

class MunicipalityEntity extends Equatable {
  final String id;
  final String municipalId;
  final String name;

  const MunicipalityEntity({
    required this.id,
    required this.municipalId,
    required this.name,
  });

  @override
  List<Object?> get props => [id, municipalId, name];
}
