// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:balady_plus/app/features/commercial_license/commercial_license_exports.dart';
import 'package:flutter/foundation.dart';

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
  DeedInfoResponse? deedInfo;
  EjarInfoResponse? ejarContractInfo;
  CleanContractItem? cleanContractInfo;
}
