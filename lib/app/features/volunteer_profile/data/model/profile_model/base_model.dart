import '../../../domain/entities/profile_entity/base_entity.dart';

class BaseModel extends BaseEntity {
  const BaseModel({
    super.id,
    super.name,
  });

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(id: json['id'], name: json['name']);

  BaseEntity toEntity() => BaseEntity(id: id, name: name);
}
