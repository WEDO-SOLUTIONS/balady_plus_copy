import '../../dashboard_exports.dart' show DashboardProductEntity;

class DashboardProductModel extends DashboardProductEntity {
  const DashboardProductModel({
    required super.id,
    required super.name,
  });

  factory DashboardProductModel.fromMap(Map<String, dynamic> json) {
    return DashboardProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
