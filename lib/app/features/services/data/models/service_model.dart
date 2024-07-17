import 'package:localize_and_translate/localize_and_translate.dart';

import '../../services_exports.dart'
    show ServiceActionModel, ServiceCardEntity, ServiceCardModel, ServiceEntity;

class ServiceModel extends ServiceEntity {
  const ServiceModel(
      {required super.id,
      required super.title,
      required super.iconName,
      required super.order,
      required super.isNew,
      required super.isImportant,
      super.icon3DName,
      super.description,
      super.tag,
      required super.action,
      super.cards = const [],
      super.warning,
      super.requireLogin,
      super.beta});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    json.addAll(json["ar"] as Map<String, dynamic>);
    final List<ServiceCardEntity> cardList = [];
    for (final card in json['cards'] ?? []) {
      cardList.add(ServiceCardModel.fromJson(card));
    }
    return ServiceModel(
        id: json["id"] as int,
        title: json['title'] as String,
        iconName: json['icon'] as String,
        order: json['order'] as int,
        isNew: json['isNew'] as bool,
        isImportant: json['isImportant'] as bool,
        icon3DName: json['3d_icon'] as String?,
        description: json['description'] as String?,
        tag: json['tag'] as String?,
        action: ServiceActionModel.fromJson(json['action']),
        cards: cardList,
        warning: json['warning'] as String?,
        requireLogin: json["requireLogin"],
        beta: json["beta"] ?? false);
  }
}
