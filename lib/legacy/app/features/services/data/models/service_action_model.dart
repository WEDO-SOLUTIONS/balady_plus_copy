import 'package:balady_plus/app/features/services/services_exports.dart';

import '../../../../core/utils/utils_exports.dart' show ServiceAction;

class ServiceActionModel extends ServiceActionEntity {
  const ServiceActionModel({
    required super.type,
    required super.value,
  });

  factory ServiceActionModel.fromJson(Map<String, dynamic> json) {
    return ServiceActionModel(
      type: ServiceAction.values.firstWhere(
        (e) => e.type == json['type'] as String,
      ),
      value: json['value'] as String,
    );
  }
}
