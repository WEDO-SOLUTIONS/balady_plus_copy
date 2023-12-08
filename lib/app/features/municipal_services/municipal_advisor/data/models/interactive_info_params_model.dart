import 'package:equatable/equatable.dart';

class InteractiveInfoParamsModel extends Equatable {
  final String consultationKey;
  final String cleanOption;
  final String contractOption;
  final String contractType;
  final bool hasBrand;
  final bool hasShopImage;

  const InteractiveInfoParamsModel({
    required this.consultationKey,
    required this.cleanOption,
    required this.contractOption,
    required this.contractType,
    required this.hasBrand,
    required this.hasShopImage,
  });

  Map<String, dynamic> toMap() => {
        'cleaningOption': cleanOption,
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
