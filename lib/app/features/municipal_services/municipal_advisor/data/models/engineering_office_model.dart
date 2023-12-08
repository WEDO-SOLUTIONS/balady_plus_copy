import '../../municipal_advisor_exports.dart' show EngineeringOfficeEntity;

class EngineeringOfficeModel extends EngineeringOfficeEntity {
  const EngineeringOfficeModel({
    required super.officeName,
    super.cityName,
    super.officeMobile,
  });

  factory EngineeringOfficeModel.fromMap(Map<String, dynamic> map) {
    return EngineeringOfficeModel(
      officeName: map['officeName'] as String,
      cityName: map['cityName'] as String?,
      officeMobile: map['officeMobile'] as String?,
    );
  }
}
