import '../../municipal_advisor_exports.dart'
    show CostInfoModel, LicenseFeesEntity, PermitsFeesModel;

class LicenseFeesModel extends LicenseFeesEntity {
  const LicenseFeesModel({
    required super.totalFees,
    required super.permissionTotalFees,
    required super.permits,
    required super.items,
  });

  //fromMap
  factory LicenseFeesModel.fromMap(Map<String, dynamic> map) {
    return LicenseFeesModel(
      totalFees: map['totalFees'] as num,
      permissionTotalFees: map['permissionTotalFees'] as num,
      permits: ((map['calculatedFees'] ?? []) as List<dynamic>)
          .map((e) => PermitsFeesModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      items: ((map['items'] ?? []) as List<dynamic>)
          .map((e) => CostInfoModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
