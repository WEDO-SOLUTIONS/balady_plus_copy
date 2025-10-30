import '../../requests_exports.dart' show RequestTypeEntity;

class RequestTypeModel extends RequestTypeEntity {
  const RequestTypeModel({
    required super.id,
    required super.name,
  });

  factory RequestTypeModel.fromMap(Map<String, dynamic> map) {
    return RequestTypeModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
