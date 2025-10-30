// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:balady_plus/app/commercial_model/features/commercial_license/commercial_license_exports.dart';

import 'commercial_board_type.dart';

class SaveShopDetailsRequest {
  int? requestId;
  String? cleanContractEndDate;
  bool? existInMall;
  int? mallId;
  int? floorNumber;
  bool? isCitizenPledgedToClean;
  String? landNumber;
  String? planNumber;
  String? shopName;
  String? shopUnitNumber;
  String? buildingLicenseDate;
  String? buildingLicenseNo;
  String? buildingOwnerIdno;
  String? buildingOwnerName;
  String? holesCount;
  String? floorCount;
  bool? hasElevator;
  String? noOfCameras;
  String? contractDate;
  String? contractNumber;
  String? contractOption;
  String? contractType;
  String? salamaBillNumber;
  String? slamaReportNumber;
  String? cleanContractNumber;
  String? investmentContractNumber;
  String? blockNumber;
  bool? brand;
  String? salamaPermitNumber;
  bool? salamaPermitExist;
  String? boardContractNumber;
  String? selectedBoardContractOption;
  List<CommercialBoardType>? boardsInfo;
  DeedInfoRequest? deedInfo;
  EjarInfoRequest? ejarContractInfo;
  CleanContractItem? cleanContractInfo;
  bool? insidePetrolStation;
  SaveShopDetailsRequest(
      {this.requestId,
      this.cleanContractEndDate,
      this.existInMall,
      this.mallId,
      this.floorNumber,
      this.isCitizenPledgedToClean,
      this.landNumber,
      this.planNumber,
      this.shopName,
      this.shopUnitNumber,
      this.buildingLicenseDate,
      this.buildingLicenseNo,
      this.buildingOwnerIdno,
      this.buildingOwnerName,
      this.holesCount,
      this.floorCount,
      this.hasElevator,
      this.noOfCameras,
      this.contractDate,
      this.contractNumber,
      this.contractOption,
      this.contractType,
      this.salamaBillNumber,
      this.slamaReportNumber,
      this.cleanContractNumber,
      this.investmentContractNumber,
      this.blockNumber,
      this.brand,
      this.salamaPermitNumber,
      this.salamaPermitExist,
      this.boardContractNumber,
      this.selectedBoardContractOption,
      this.boardsInfo,
      this.deedInfo,
      this.ejarContractInfo,
      this.cleanContractInfo,
      this.insidePetrolStation});

  Map<String, dynamic> toMap() {
    return {
      "boardsInfo":
          boardsInfo?.map((e) => {"typeId": e.typeId, "area": e.area}).toList(),
      "cleanContractEndDate": cleanContractEndDate,
      "existInMall": existInMall,
      "mallId": mallId,
      "floorNumber": floorNumber,
      "isCitizenPledgedToClean": isCitizenPledgedToClean,
      "landNumber": landNumber,
      "planNumber": planNumber,
      "shopName": shopName,
      "shopUnitNumber": shopUnitNumber,
      "buildingLicenseDate": buildingLicenseDate,
      "buildingLicenseNo": buildingLicenseNo,
      "buildingOwnerIdno": buildingOwnerIdno,
      "buildingOwnerName": buildingOwnerName,
      "holesCount": holesCount,
      "floorCount": floorCount,
      "hasElevator": hasElevator,
      "noOfCameras": noOfCameras,
      "contractDate": contractDate,
      "contractNumber": contractNumber,
      "contractOption": contractOption,
      "contractType": contractType,
      "salamaBillNumber": salamaBillNumber,
      "slamaReportNumber": slamaReportNumber,
      "deedInfo": deedInfo?.toMap(),
      if (ejarContractInfo != null &&
          ejarContractInfo?.tenancyContractNumber != null)
        "ejarContractInfo": ejarContractInfo?.toMap(),
      "cleanContractNumber": cleanContractNumber,
      "investmentContractNumber": investmentContractNumber,
      "blockNumber": blockNumber,
      "brand": brand,
      "salamaPermitNumber": salamaPermitNumber,
      "salamaPermitExist": salamaPermitExist,
      "boardContractNumber": boardContractNumber,
      "selectedBoardContractOption": selectedBoardContractOption,
      "insidePetrolStation": insidePetrolStation
    };
  }
}
