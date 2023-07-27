import '../../municipal_advisor_exports.dart' show CommercialOfficeEntity;

class CommercialOfficeModel extends CommercialOfficeEntity {
  const CommercialOfficeModel({
    required super.officeName,
    super.cityName,
    super.officeMobile,
  });

  factory CommercialOfficeModel.fromMap(Map<String, dynamic> map) {
    return CommercialOfficeModel(
      officeName: map['officeName'] as String,
      cityName: map['cityName'] as String?,
      officeMobile: map['officeMobile'] as String?,
    );
  }
}
