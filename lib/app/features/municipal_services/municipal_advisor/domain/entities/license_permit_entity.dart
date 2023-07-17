import 'package:equatable/equatable.dart';

class LicensePermitEntity extends Equatable {
  final String name;
  final num cost;

  const LicensePermitEntity({
    required this.name,
    required this.cost,
  });

  @override
  List<Object?> get props => [name, cost];
}
