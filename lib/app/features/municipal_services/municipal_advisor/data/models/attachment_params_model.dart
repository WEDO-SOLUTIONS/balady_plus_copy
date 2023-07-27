import 'package:equatable/equatable.dart';

class AttachmentParamsModel extends Equatable {
  final String consultationKey;
  final String cleanOption;
  final String contractOption;
  final String contractType;
  final bool hasBrand;
  final bool hasShopImage;

  const AttachmentParamsModel({
    required this.consultationKey,
    required this.cleanOption,
    required this.contractOption,
    required this.contractType,
    required this.hasBrand,
    required this.hasShopImage,
  });

  Map<String, dynamic> toMap() => {
        'cleanOption': cleanOption,
        'contractOption': contractOption,
        'contractType': contractType,
        'hasBrand': hasBrand,
        'hasShopImage': hasShopImage,
      };

  @override
  List<Object?> get props => [
        consultationKey,
        cleanOption,
        contractOption,
        contractType,
        hasBrand,
        hasShopImage,
      ];
}
