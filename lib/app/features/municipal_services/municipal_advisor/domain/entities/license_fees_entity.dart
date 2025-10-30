import 'package:equatable/equatable.dart';

import '../../municipal_advisor_exports.dart'
    show CostInfoEntity, PermitsFeesEntity;

class LicenseFeesEntity extends Equatable {
  final num totalFees;
  final num permissionTotalFees;
  final List<PermitsFeesEntity> permits;
  final List<CostInfoEntity> items;

  const LicenseFeesEntity({
    required this.totalFees,
    required this.permissionTotalFees,
    required this.permits,
    required this.items,
  });

  @override
  List<Object?> get props => [
        totalFees,
        permissionTotalFees,
        permits,
        items,
      ];
}
