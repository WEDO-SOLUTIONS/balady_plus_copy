import 'package:balady_plus/app/features/services/domain/entities/service_action_entity.dart';
import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final String title;
  final String iconName;
  final String? icon3DName;
  final int order;
  final bool isNew;
  final bool isImportant;
  final String? description;
  final String? tag;
  final ServiceActionEntity action;

  const ServiceEntity({
    required this.title,
    required this.iconName,
    required this.order,
    required this.isNew,
    required this.isImportant,
    this.icon3DName,
    this.description,
    this.tag,
    required this.action,
  });

  @override
  List<Object?> get props => [
        title,
        iconName,
        order,
        isNew,
        isImportant,
        icon3DName,
        description,
        tag,
        action,
      ];
}
