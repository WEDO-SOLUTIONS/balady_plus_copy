// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class SaveConsultationProgressParamsModel extends Equatable {
  final String consultationKey;
  final String? subMunicipalityGisCode;
  final int? districtCode;
  final int? streetCode;
  final String longitude;
  final String latitude;
  final String? mapNo;
  final String? landNo;
  final num mainActivityArea;
  final int activityId;
  final bool? atmFeesOption;
  final int? unitCount;
  final int? accommodationTypeId;
  final String? krokiUrl;

  const SaveConsultationProgressParamsModel({
    required this.consultationKey,
    required this.subMunicipalityGisCode,
    required this.districtCode,
    required this.streetCode,
    required this.longitude,
    required this.latitude,
    required this.mapNo,
    required this.landNo,
    required this.mainActivityArea,
    required this.activityId,
    required this.atmFeesOption,
    required this.unitCount,
    required this.accommodationTypeId,
    required this.krokiUrl,
  });

  @override
  List<Object?> get props => [
        consultationKey,
        subMunicipalityGisCode,
        districtCode,
        streetCode,
        longitude,
        latitude,
        mapNo,
        landNo,
        mainActivityArea,
        activityId,
        atmFeesOption,
        unitCount,
        accommodationTypeId,
        krokiUrl,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'consultationKey': consultationKey,
      'subMunicipalityGisCode': subMunicipalityGisCode,
      'districtCode': districtCode,
      'streetCode': streetCode,
      'longitude': longitude,
      'latitude': latitude,
      'mapNo': mapNo,
      'landNo': landNo,
      'mainActivityArea': mainActivityArea,
      'activityId': activityId,
      'atmFeesOption': atmFeesOption,
      'unitCount': unitCount,
      'accommodationTypeId': accommodationTypeId,
      'krokiUrl': krokiUrl,
    };
  }
}
