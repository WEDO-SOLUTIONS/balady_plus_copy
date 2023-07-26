import 'package:equatable/equatable.dart';

class CostInfoEntity extends Equatable {
  final String costItemDescription;
  final int costItemTypeId;
  final num costItemValue;
  final int? serviceTypeId;

  const CostInfoEntity({
    required this.costItemDescription,
    required this.costItemTypeId,
    required this.costItemValue,
    required this.serviceTypeId,
  });

  @override
  List<Object?> get props => [
        costItemDescription,
        costItemTypeId,
        costItemValue,
        serviceTypeId,
      ];
}
