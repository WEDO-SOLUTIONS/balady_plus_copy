import '../../objections_exports.dart' show RequestSubTypeEntity;

class RequestSubTypeModel extends RequestSubTypeEntity {
  const RequestSubTypeModel({
    super.id,
    super.name,
  });

  factory RequestSubTypeModel.fromMap(Map<String, dynamic> map) {
    return RequestSubTypeModel(
      id: map['id'],
      name: map['name'],
    );
  }
}
