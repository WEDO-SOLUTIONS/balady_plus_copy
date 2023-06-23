import '../../dashboard_exports.dart' show DashboardStatisticsEntity;

class DashboardStatisticsModel extends DashboardStatisticsEntity {
  const DashboardStatisticsModel({
    required super.keyId,
    required super.keyName,
    required super.count,
  });

  factory DashboardStatisticsModel.fromMap(Map<String, dynamic> json) {
    return DashboardStatisticsModel(
      keyId: json['keyId'] as int,
      keyName: json['keyName'] as String,
      count: json['count'] as int,
    );
  }
}
