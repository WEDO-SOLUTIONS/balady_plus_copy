// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SaveLocationDataRequest {
  int? requestId;
  String? streetCode;
  String? subMunicipalityGisCode;
  String? districtCode;
  String? krokiUrl;
  double? latitude;
  double? longitude;
  String? landNo;
  String? mapNo;

  SaveLocationDataRequest(
      {this.requestId,
      this.streetCode,
      this.subMunicipalityGisCode,
      this.districtCode,
      this.krokiUrl,
      this.latitude,
      this.longitude,
      this.landNo,
      this.mapNo});

  SaveLocationDataRequest copyWith(
      {int? requestId,
      String? streetCode,
      String? subMunicipalityGisCode,
      String? districtCode,
      String? krokiUrl,
      double? latitude,
      double? longitude,
      String? landNo,
      String? mapNo}) {
    return SaveLocationDataRequest(
        requestId: requestId ?? this.requestId,
        streetCode: streetCode ?? this.streetCode,
        subMunicipalityGisCode:
            subMunicipalityGisCode ?? this.subMunicipalityGisCode,
        districtCode: districtCode ?? this.districtCode,
        krokiUrl: krokiUrl ?? this.krokiUrl,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        landNo: landNo ?? this.landNo,
        mapNo: mapNo ?? this.mapNo);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'streetCode': streetCode,
      'subMunicipalityGisCode': subMunicipalityGisCode,
      'districtCode': districtCode,
      'krokiUrl': krokiUrl,
      'latitude': latitude,
      'longitude': longitude,
      "mapNo": mapNo,
      "landNo": landNo
    };
  }

  factory SaveLocationDataRequest.fromMap(Map<String, dynamic> map) {
    return SaveLocationDataRequest(
      streetCode:
          map['streetCode'] != null ? map['streetCode'] as String : null,
      subMunicipalityGisCode: map['subMunicipalityGisCode'] != null
          ? map['subMunicipalityGisCode'] as String
          : null,
      districtCode:
          map['districtCode'] != null ? map['districtCode'] as String : null,
      krokiUrl: map['krokiUrl'] != null ? map['krokiUrl'] as String : null,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SaveLocationDataRequest.fromJson(String source) =>
      SaveLocationDataRequest.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SaveLocationDataRequest(streetCode: $streetCode, subMunicipalityGisCode: $subMunicipalityGisCode, districtCode: $districtCode, krokiUrl: $krokiUrl, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(covariant SaveLocationDataRequest other) {
    if (identical(this, other)) return true;

    return other.streetCode == streetCode &&
        other.subMunicipalityGisCode == subMunicipalityGisCode &&
        other.districtCode == districtCode &&
        other.krokiUrl == krokiUrl &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return streetCode.hashCode ^
        subMunicipalityGisCode.hashCode ^
        districtCode.hashCode ^
        krokiUrl.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }
}
