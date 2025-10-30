import '../../dashboard_exports.dart' show DashboardStatisticsParamsModel;

class DashboardStatisticsParams extends DashboardStatisticsParamsModel {
  const DashboardStatisticsParams({
    super.productId,
    super.unifiedNationalNumber,
    super.identityNumber,
    required super.mainCardId,
  });
}
