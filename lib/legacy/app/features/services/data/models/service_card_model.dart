import 'package:localize_and_translate/localize_and_translate.dart';

import '../../services_exports.dart' show ServiceCardEntity;

class ServiceCardModel extends ServiceCardEntity {
  const ServiceCardModel({
    required super.title,
    required super.iconName,
    required super.description,
    required super.rate,
    required super.duration,
  });

  factory ServiceCardModel.fromJson(Map<String, dynamic> json) {
    json.addAll(json[translator.activeLanguageCode] as Map<String, dynamic>);
    final service = ServiceCardModel(
      title: json['title'] as String,
      iconName: json['iconName'] as String,
      description: json['description'] as String,
      rate: json['rate'] as num,
      duration: json['duration'] as int,
    );

    return service;
  }
}
