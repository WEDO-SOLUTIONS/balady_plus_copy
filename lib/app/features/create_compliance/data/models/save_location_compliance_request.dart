// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class SaveLocationComplianceRequest extends Equatable {
  final int? mainUsageCode;
  final int? subUsageCode;
  final String? municipalityId;
  final String? subMunicipalityId;
  final String? districtId;
  final String? cityId;
  final String? streetId;
  final String? streetName;
  final String? mapNumber;
  final String? mapName;
  final String? x;
  final String? y;
  final String? landNumber;
  final String? landArea;
  final String? guid;
  final int? requsestId;
  final bool? isLicense;
  final bool? isEmtithalMand;

  const SaveLocationComplianceRequest(
      {this.mainUsageCode,
      this.subUsageCode,
      this.municipalityId,
      this.subMunicipalityId,
      this.districtId,
      this.cityId,
      this.streetId,
      this.streetName,
      this.mapNumber,
      this.mapName,
      this.x,
      this.y,
      this.landNumber,
      this.landArea,
      this.guid,
      this.requsestId,
      this.isLicense,
      this.isEmtithalMand});

  @override
  List<Object?> get props => [
        mainUsageCode,
        subUsageCode,
        municipalityId,
        subMunicipalityId,
        districtId,
        cityId,
        streetId,
        streetName,
        mapNumber,
        mapName,
        x,
        y,
        landNumber,
        landArea,
        guid,
        requsestId,
        isLicense,
        isEmtithalMand
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mainUsageCode': mainUsageCode,
      'subUsageCode': subUsageCode,
      'isEmtithalMand': isEmtithalMand,
      if (isLicense != true)
        "geoInfoDto": {
          'municipalityId': municipalityId,
          'subMunicipalityId': subMunicipalityId,
          'districtId': districtId,
          'cityId': cityId,
          'streetId': streetId,
          'streetName': streetName,
          'mapNumber': mapNumber,
          'mapName': mapName,
          'x': x,
          'y': y,
          'landNumber': landNumber,
          'landArea': landArea,
          'guid': guid,
        }
    };
  }
}
