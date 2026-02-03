
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_product_entity.dart';

class DashboardProductModel extends
DashboardProductEntity {
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
