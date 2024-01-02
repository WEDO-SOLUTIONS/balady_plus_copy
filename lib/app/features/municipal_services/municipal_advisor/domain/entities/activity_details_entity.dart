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
  final bool isAtm;
  final bool isHotel;
  final bool? homogeneous;
  String? inputArea;

  ActivityDetailsEntity(
      {required this.activityId,
      required this.activityName,
      required this.isicNumber,
      required this.isicName,
      required this.masterActivityId,
      required this.masterActivityName,
      required this.facilityId,
      required this.facilityName,
      required this.minimumArea,
      required this.maximumArea,
      required this.isAtm,
      required this.isHotel,
      required this.homogeneous,
      this.inputArea});

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
        isAtm,
        isHotel,
        homogeneous,
        inputArea
      ];

  String? get text => activityName;
}
