import '../../municipal_advisor_exports.dart';

class InteractiveInfoParams extends InteractiveInfoParamsModel {
  const InteractiveInfoParams({
    required super.consultationKey,
    required super.cleanOption,
    required super.contractOption,
    required super.contractType,
    required super.hasBrand,
    super.hasShopImage = true,
  });
}
