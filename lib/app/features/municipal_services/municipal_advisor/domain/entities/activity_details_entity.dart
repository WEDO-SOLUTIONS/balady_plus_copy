import 'package:equatable/equatable.dart';

class ActivityDetailsEntity extends Equatable {
  final int activityId;
  final String activityName;
  final int isicNumber;
  final String isicName;
  final int masterActivityId;
  final String masterActivityName;
  final int facilityId;
  final String facilityName;
  final num minimumArea;
  final num maximumArea;

  const ActivityDetailsEntity({
    required this.activityId,
    required this.activityName,
    required this.isicNumber,
    required this.isicName,
    required this.masterActivityId,
    required this.masterActivityName,
    required this.facilityId,
    required this.facilityName,
    required this.minimumArea,
    required this.maximumArea,
  });

  @override
  List<Object?> get props => [
        activityId,
        activityName,
        isicNumber,
        isicName,
        masterActivityId,
        masterActivityName,
        facilityId,
        facilityName,
        minimumArea,
        maximumArea,
      ];
}
