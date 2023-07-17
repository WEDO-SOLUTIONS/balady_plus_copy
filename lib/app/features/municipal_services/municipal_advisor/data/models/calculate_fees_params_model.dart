import 'package:equatable/equatable.dart';

import '../../municipal_advisor_exports.dart'
    show BoardsParamsModel, PermitsParamsModel;

class CalculateFeesParamsModel extends Equatable {
  final String consultationKey;
  final String municipalityGisCode;
  final String longitude;
  final String latitude;
  final int activityId;
  final int licensePeriod;
  final num shopArea;
  final String? cleanOption;
  final int? unitCount;
  final int? accommodationTypeId;
  final List<PermitsParamsModel> permits;
  final List<BoardsParamsModel> boards;
  final bool? atmFeesPaid;

  const CalculateFeesParamsModel({
    required this.consultationKey,
    required this.municipalityGisCode,
    required this.longitude,
    required this.latitude,
    required this.activityId,
    required this.licensePeriod,
    required this.shopArea,
    required this.cleanOption,
    required this.unitCount,
    required this.accommodationTypeId,
    required this.permits,
    required this.boards,
    required this.atmFeesPaid,
  });

  Map<String, dynamic> toMap() {
    return {
      'municipalityGisCode': municipalityGisCode,
      'longitude': longitude,
      'latitude': latitude,
      'activityId': activityId,
      'licensePeriod': licensePeriod,
      'shopArea': shopArea,
      'cleanOption': cleanOption,
      'unitCount': unitCount,
      'accommodationTypeId': accommodationTypeId,
      'permits': permits.map((x) => x.toMap()).toList(),
      'boards': boards.map((x) => x.toMap()).toList(),
      'atmFeesPaid': atmFeesPaid,
    };
  }

  @override
  List<Object?> get props => [
        municipalityGisCode,
        longitude,
        latitude,
        activityId,
        licensePeriod,
        shopArea,
        cleanOption,
        unitCount,
        accommodationTypeId,
        permits,
        boards,
        atmFeesPaid,
      ];
}
