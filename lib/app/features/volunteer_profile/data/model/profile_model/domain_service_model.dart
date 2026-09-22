import '../../../domain/entities/profile_entity/domain_service_entity.dart';

class DomainServiceModel extends DomainServiceEntity {
  const DomainServiceModel({
    super.id,
    super.name,
    super.parentId,
    super.parentName,
  });

  factory DomainServiceModel.fromJson(Map<String, dynamic> json) =>
      DomainServiceModel(
        id: json['id'],
        name: json['name'],
        parentId: json['parentId'],
        parentName: json['parentName'],
      );

  DomainServiceEntity toEntity() => DomainServiceEntity(
        id: id,
        name: name,
        parentId: parentId,
        parentName: parentName,
      );
}
