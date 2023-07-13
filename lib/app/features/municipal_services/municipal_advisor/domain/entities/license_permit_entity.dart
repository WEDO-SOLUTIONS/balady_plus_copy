import 'package:equatable/equatable.dart';

class LicensePermitEntity extends Equatable {
  final int id;
  final String name;
  final num cost;

  const LicensePermitEntity({
    required this.id,
    required this.name,
    required this.cost,
  });

  @override
  List<Object?> get props => [id, name, cost];
}
