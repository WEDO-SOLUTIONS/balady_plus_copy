import '../../objections_exports.dart' show RequestTypeEntity;

class RequestTypeModel extends RequestTypeEntity {
  const RequestTypeModel({
    super.id,
    super.nameAr,
    super.nameEn,
  });

  factory RequestTypeModel.fromMap(Map<String, dynamic> map) {
    return RequestTypeModel(
        id: map['id'], nameAr: map['nameAr'], nameEn: map['nameEn']);
  }
}
