import '../../objections_exports.dart' show RequestTypeEntity;

class RequestTypeModel extends RequestTypeEntity {
  const RequestTypeModel({
    super.id,
    super.name,
  });

  factory RequestTypeModel.fromMap(Map<String, dynamic> map) {
    return RequestTypeModel(
      id: map['id'],
      name: map['nameAr'],
    );
  }
}
