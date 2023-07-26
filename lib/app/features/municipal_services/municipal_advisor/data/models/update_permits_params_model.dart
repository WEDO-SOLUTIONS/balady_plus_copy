import 'package:equatable/equatable.dart';

class UpdatePermitParamsModel extends Equatable {
  final String consultationKey;
  final num permitTypeId;
  final num? nonFoodVehicleCount;
  final num? sideWalkDays;
  final num? sideWalkLength;
  final num? sideWalkWidth;

  const UpdatePermitParamsModel({
    required this.consultationKey,
    required this.permitTypeId,
    this.nonFoodVehicleCount,
    this.sideWalkDays,
    this.sideWalkLength,
    this.sideWalkWidth,
  });

  Map<String, dynamic> toMap() {
    return {
      'permitTypeId': permitTypeId,
      'nonFoodVehicleCount': nonFoodVehicleCount,
      'sideWalkDays': sideWalkDays,
      'sideWalkLength': sideWalkLength,
      'sideWalkWidth': sideWalkWidth,
    };
  }

  @override
  List<Object?> get props => [
        consultationKey,
        permitTypeId,
        nonFoodVehicleCount,
        sideWalkDays,
        sideWalkLength,
        sideWalkWidth,
      ];
}
