import '../../municipal_advisor_exports.dart'
    show PermitsParamsModel, SideWalkParamsModel;

class PermitsParams extends PermitsParamsModel {
  const PermitsParams({
    required super.permitTypeId,
    required super.sideWalk,
    required super.nonFoodVehicleCount,
    required super.permitName,
  });

  PermitsParams copyWith({
    int? permitTypeId,
    SideWalkParamsModel? sideWalk,
    int? nonFoodVehicleCount,
    String? permitName,
  }) {
    return PermitsParams(
      permitTypeId: permitTypeId ?? this.permitTypeId,
      sideWalk: sideWalk ?? this.sideWalk,
      nonFoodVehicleCount: nonFoodVehicleCount ?? this.nonFoodVehicleCount,
      permitName: permitName ?? this.permitName,
    );
  }
}
