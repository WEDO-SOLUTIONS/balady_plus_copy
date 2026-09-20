import 'base_entity.dart';

class DomainServiceEntity extends BaseEntity {
  final int? parentId;
  final String? parentName;

  const DomainServiceEntity({
    required super.id,
    required super.name,
    required this.parentId,
    required this.parentName,
  });
}
