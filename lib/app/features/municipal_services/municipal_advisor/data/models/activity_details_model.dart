import '../../municipal_advisor_exports.dart' show ActivityDetailsEntity;

class ActivityDetailsModel extends ActivityDetailsEntity {
  const ActivityDetailsModel({
    required super.activityId,
    required super.activityName,
    required super.isicNumber,
    required super.isicName,
    required super.masterActivityId,
    required super.masterActivityName,
    required super.facilityId,
    required super.facilityName,
    required super.minimumArea,
    required super.maximumArea,
    required super.isAtm,
    required super.isHotel,
  });

  factory ActivityDetailsModel.fromMap(Map<String, dynamic> map) {
    return ActivityDetailsModel(
      activityId: map['activityId'] as int,
      activityName: map['activityName'] as String,
      isicNumber: map['isicNumber'] as int,
      isicName: map['isicName'] as String,
      masterActivityId: map['masterActivityId'] as int,
      masterActivityName: map['masterActivityName'] as String,
      facilityId: map['facilityId'] as int,
      facilityName: map['facilityName'] as String,
      minimumArea: map['minimumArea'] as double? ?? 0,
      maximumArea: map['maximumArea'] as double? ?? double.infinity,
      isAtm: map['isAtm'] as bool? ?? false,
      isHotel: map['isHotel'] as bool? ?? false,
    );
  }
}
