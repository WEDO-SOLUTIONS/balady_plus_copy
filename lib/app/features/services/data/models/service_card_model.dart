import 'package:localize_and_translate/localize_and_translate.dart';

import '../../services_exports.dart' show ServiceCardEntity, ServiceCardFlow;

class ServiceCardModel extends ServiceCardEntity {
  const ServiceCardModel(
      {required super.title,
      required super.iconName,
      required super.description,
      required super.rate,
      required super.duration,
      super.fees,
      super.feesName,
      super.feesLink,
      super.type,
      super.requirements,
      super.flow,
      super.descriptionLink});

  factory ServiceCardModel.fromJson(Map<String, dynamic> json) {
    json.addAll(json["ar"] as Map<String, dynamic>);
    final service = ServiceCardModel(
      title: json['title'] as String,
      iconName: json['iconName'] as String,
      fees: json['fees'],
      feesName: json['feesName'],
      feesLink: json['feesLink'],
      type: json["type"],
      description: json['description'] as String,
      descriptionLink: json["descriptionLink"],
      rate: json['rate'] as num,
      requirements: json["requirements"] != null
          ? List<String>.from(json["requirements"]).map((e) => e).toList()
          : null,
      duration: json['duration'],
      flow: json["flow"] != null
          ? List<dynamic>.from(json["flow"])
              .map((e) => ServiceCardFlow.fromMap(e))
              .toList()
          : null,
    );

    return service;
  }
}
