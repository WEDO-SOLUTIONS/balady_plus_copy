import 'package:equatable/equatable.dart';

class LicensePermitEntity extends Equatable {
  final int permitTypeId;
  final String name;
  final num cost;
  final int calculatorServiceId;

  const LicensePermitEntity({
    required this.permitTypeId,
    required this.name,
    required this.cost,
    required this.calculatorServiceId,
  });

  @override
  List<Object?> get props => [
        permitTypeId,
        name,
        cost,
        calculatorServiceId,
      ];
}
