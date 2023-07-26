import 'package:equatable/equatable.dart';

import '../../municipal_advisor_exports.dart' show SideWalkParamsModel;

class PermitsParamsModel extends Equatable {
  final int permitTypeId;
  final SideWalkParamsModel? sideWalk;
  final int? nonFoodVehicleCount;
  final String? permitName;

  const PermitsParamsModel({
    required this.permitTypeId,
    required this.sideWalk,
    required this.nonFoodVehicleCount,
    required this.permitName,
  });

  Map<String, dynamic> toMap() {
    return {
      'permitTypeId': permitTypeId,
      'sideWalk': sideWalk?.toMap(),
      'nonFoodVehicleCount': nonFoodVehicleCount,
      'permitName': permitName,
    };
  }

  @override
  List<Object?> get props => [
        permitTypeId,
        sideWalk,
        nonFoodVehicleCount,
        permitName,
      ];
}
