import '../../requests_exports.dart' show RequestSubTypeEntity;

class RequestSubTypeModel extends RequestSubTypeEntity {
  const RequestSubTypeModel({
    required super.id,
    required super.name,
  });

  factory RequestSubTypeModel.fromMap(Map<String, dynamic> map) {
    return RequestSubTypeModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
