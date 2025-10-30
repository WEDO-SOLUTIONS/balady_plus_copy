import '../../requests_exports.dart' show RequestStatusEntity;

class RequestStatusModel extends RequestStatusEntity {
  const RequestStatusModel({
    required super.id,
    required super.name,
  });

  factory RequestStatusModel.fromMap(Map<String, dynamic> map) {
    return RequestStatusModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
