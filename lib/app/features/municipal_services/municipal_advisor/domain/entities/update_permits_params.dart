import '../../municipal_advisor_exports.dart';

class UpdatePermitParams extends UpdatePermitParamsModel {
  const UpdatePermitParams({
    required super.consultationKey,
    required super.permitTypeId,
    super.nonFoodVehicleCount,
    super.sideWalkDays,
    super.sideWalkLength,
    super.sideWalkWidth,
  });
}
