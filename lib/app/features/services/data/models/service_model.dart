import 'package:localize_and_translate/localize_and_translate.dart';

import '../../services_exports.dart' show ServiceActionModel, ServiceEntity;

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.title,
    required super.iconName,
    required super.order,
    required super.isNew,
    required super.isImportant,
    super.icon3DName,
    super.description,
    super.tag,
    required super.action,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    json.addAll(json[translator.activeLanguageCode] as Map<String, dynamic>);
    return ServiceModel(
      title: json['title'] as String,
      iconName: json['icon'] as String,
      order: json['order'] as int,
      isNew: json['isNew'] as bool,
      isImportant: json['isImportant'] as bool,
      icon3DName: json['3d_icon'] as String?,
      description: json['description'] as String?,
      tag: json['tag'] as String?,
      action: ServiceActionModel.fromJson(json['action']),
    );
  }
}
