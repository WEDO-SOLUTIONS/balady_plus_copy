import '../../municipal_advisor_exports.dart';

class AttachmentParams extends AttachmentParamsModel {
  const AttachmentParams({
    required super.consultationKey,
    required super.cleanOption,
    required super.contractOption,
    required super.contractType,
    required super.hasBrand,
    super.hasShopImage = true,
  });
}
