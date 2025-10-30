// To parse this JSON data, do
//
//     final landSubsidyContract = landSubsidyContractFromJson(jsonString);

import 'package:equatable/equatable.dart';

class LandSubsidyContract extends Equatable {
  final int? idType;
  final String? nationalIdNumber;
  final String? name;
  final String? emailAddress;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? contractNumber;
  final String? contractDateAd;
  final String? contractDateHijri;
  final String? planNumber;
  final int? unitSize;
  final String? blockNumber;
  final String? landNumber;
  final String? limitNorthward;
  final String? limitSouthward;
  final String? limitEastward;
  final String? limitWestward;
  final String? lengthNorthward;
  final String? lengthSouthward;
  final String? lengthEastward;
  final String? lengthWestward;
  final String? easting1;
  final String? easting2;
  final String? easting3;
  final String? easting4;
  final String? easting5;
  final String? easting6;
  final String? easting7;
  final String? easting8;
  final String? easting9;
  final String? easting10;
  final String? northing1;
  final String? northing2;
  final String? northing3;
  final String? northing4;
  final String? northing5;
  final String? northing6;
  final String? northing7;
  final String? northing8;
  final String? northing9;
  final String? northing10;
  final int? projectLatitude;
  final int? projectLongitude;
  final int? farzStatus;

  LandSubsidyContract({
    this.idType,
    this.nationalIdNumber,
    this.name,
    this.emailAddress,
    this.phoneNumber,
    this.dateOfBirth,
    this.contractNumber,
    this.contractDateAd,
    this.contractDateHijri,
    this.planNumber,
    this.unitSize,
    this.blockNumber,
    this.landNumber,
    this.limitNorthward,
    this.limitSouthward,
    this.limitEastward,
    this.limitWestward,
    this.lengthNorthward,
    this.lengthSouthward,
    this.lengthEastward,
    this.lengthWestward,
    this.easting1,
    this.easting2,
    this.easting3,
    this.easting4,
    this.easting5,
    this.easting6,
    this.easting7,
    this.easting8,
    this.easting9,
    this.easting10,
    this.northing1,
    this.northing2,
    this.northing3,
    this.northing4,
    this.northing5,
    this.northing6,
    this.northing7,
    this.northing8,
    this.northing9,
    this.northing10,
    this.projectLatitude,
    this.projectLongitude,
    this.farzStatus,
  });

  factory LandSubsidyContract.fromJson(Map<String, dynamic> json) =>
      LandSubsidyContract(
        idType: json["id_type"],
        nationalIdNumber: json["national_id_number"],
        name: json["name"],
        emailAddress: json["email_address"],
        phoneNumber: json["phone_number"],
        dateOfBirth: json["date_of_birth"],
        contractNumber: json["contract_number"],
        contractDateAd: json["contract_date_ad"],
        contractDateHijri: json["contract_date_hijri"],
        planNumber: json["plan_number"],
        unitSize: json["unit_size"],
        blockNumber: json["block_number"],
        landNumber: json["land_number"],
        limitNorthward: json["limit_northward"],
        limitSouthward: json["limit_southward"],
        limitEastward: json["limit_eastward"],
        limitWestward: json["limit_westward"],
        lengthNorthward: json["length_northward"],
        lengthSouthward: json["length_southward"],
        lengthEastward: json["length_eastward"],
        lengthWestward: json["length_westward"],
        easting1: json["easting_1"],
        easting2: json["easting_2"],
        easting3: json["easting_3"],
        easting4: json["easting_4"],
        easting5: json["easting_5"],
        easting6: json["easting_6"],
        easting7: json["easting_7"],
        easting8: json["easting_8"],
        easting9: json["easting_9"],
        easting10: json["easting_10"],
        northing1: json["northing_1"],
        northing2: json["northing_2"],
        northing3: json["northing_3"],
        northing4: json["northing_4"],
        northing5: json["northing_5"],
        northing6: json["northing_6"],
        northing7: json["northing_7"],
        northing8: json["northing_8"],
        northing9: json["northing_9"],
        northing10: json["northing_10"],
        projectLatitude: json["project_latitude"],
        projectLongitude: json["project_longitude"],
        farzStatus: json["farz_status"],
      );

  String? getDate() {
    return "${contractDateHijri.toString().substring(0, 4)}/${contractDateHijri.toString().substring(4, 6)}/${contractDateHijri.toString().substring(6, 8)}";
  }

  @override
  List<Object?> get props => [idType, landNumber];
}
