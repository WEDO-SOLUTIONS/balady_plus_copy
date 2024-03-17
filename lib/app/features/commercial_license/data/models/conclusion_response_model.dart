// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final issueCommercialConculsion = issueCommercialConculsionFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';

IssueCommercialConculsion issueCommercialConculsionFromJson(String str) =>
    IssueCommercialConculsion.fromJson(json.decode(str));

String issueCommercialConculsionToJson(IssueCommercialConculsion data) =>
    json.encode(data.toJson());

class IssueCommercialConculsion {
  final int? requestId;
  final int? licenseId;
  final Owner? owner;
  final MainActivity? mainActivity;
  final List<MainActivity>? addedActivities;
  final Submitter? submitter;
  final Location? location;
  final ShopInfo? shopInfo;
  final CleaningInfo? cleaningInfo;
  final ContractInfo? contractInfo;
  final SalamaInfo? salamaInfo;
  final GovernmentalApprovals? governmentalApprovals;
  final dynamic sendToGeneralSecurityText;
  final List<WorkFlowStep>? workFlowSteps;
  final CalculatorResponse? calculatorResponse;
  final List<Attachment>? attachments;

  IssueCommercialConculsion({
    this.requestId,
    this.licenseId,
    this.owner,
    this.mainActivity,
    this.addedActivities,
    this.submitter,
    this.location,
    this.shopInfo,
    this.cleaningInfo,
    this.contractInfo,
    this.salamaInfo,
    this.governmentalApprovals,
    this.sendToGeneralSecurityText,
    this.workFlowSteps,
    this.calculatorResponse,
    this.attachments,
  });

  factory IssueCommercialConculsion.fromJson(Map<String, dynamic> json) =>
      IssueCommercialConculsion(
        requestId: json["requestId"],
        licenseId: json["licenseId"],
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
        mainActivity: json["mainActivity"] == null
            ? null
            : MainActivity.fromJson(json["mainActivity"]),
        addedActivities: json["addedActivities"] == null
            ? []
            : List<MainActivity>.from(
                json["addedActivities"]!.map((x) => MainActivity.fromJson(x))),
        submitter: json["submitter"] == null
            ? null
            : Submitter.fromJson(json["submitter"]),
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        shopInfo: json["shopInfo"] == null
            ? null
            : ShopInfo.fromJson(json["shopInfo"]),
        cleaningInfo: json["cleaningInfo"] == null
            ? null
            : CleaningInfo.fromJson(json["cleaningInfo"]),
        contractInfo: json["contractInfo"] == null
            ? null
            : ContractInfo.fromJson(json["contractInfo"]),
        salamaInfo: json["salamaInfo"] == null
            ? null
            : SalamaInfo.fromJson(json["salamaInfo"]),
        governmentalApprovals: json["governmentalApprovals"] == null
            ? null
            : GovernmentalApprovals.fromJson(json["governmentalApprovals"]),
        sendToGeneralSecurityText: json["sendToGeneralSecurityText"],
        workFlowSteps: json["workFlowSteps"] == null
            ? []
            : List<WorkFlowStep>.from(
                json["workFlowSteps"]!.map((x) => WorkFlowStep.fromJson(x))),
        calculatorResponse: json["calculatorResponse"] == null
            ? null
            : CalculatorResponse.fromJson(json["calculatorResponse"]),
        attachments: json["attachments"] == null
            ? []
            : List<Attachment>.from(
                json["attachments"]!.map((x) => Attachment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "licenseId": licenseId,
        "owner": owner?.toJson(),
        "mainActivity": mainActivity?.toJson(),
        "addedActivities": addedActivities == null
            ? []
            : List<dynamic>.from(addedActivities!.map((x) => x)),
        "submitter": submitter?.toJson(),
        "location": location?.toJson(),
        "shopInfo": shopInfo?.toJson(),
        "cleaningInfo": cleaningInfo?.toJson(),
        "contractInfo": contractInfo?.toJson(),
        "salamaInfo": salamaInfo?.toJson(),
        "governmentalApprovals": governmentalApprovals,
        "sendToGeneralSecurityText": sendToGeneralSecurityText,
        "workFlowSteps": workFlowSteps == null
            ? []
            : List<dynamic>.from(workFlowSteps!.map((x) => x.toJson())),
        "calculatorResponse": calculatorResponse?.toJson(),
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x.toJson())),
      };
}

class Attachment {
  final String? name;
  final String? attachUrl;
  final String? attachDescription;

  Attachment({
    this.name,
    this.attachUrl,
    this.attachDescription,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        name: json["name"],
        attachUrl: json["attachUrl"],
        attachDescription: json["attachDescription"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "attachUrl": attachUrl,
        "attachDescription": attachDescription,
      };
}

class CalculatorResponse {
  final double? totalCost;
  final List<CostsInfo>? costsInfo;
  final dynamic detailedCostList;
  final int? paymentYearsCount;
  final int? renewYearsCount;
  final List<ActivitiesCostDetaile>? activitiesCostDetailes;

  CalculatorResponse({
    this.totalCost,
    this.costsInfo,
    this.detailedCostList,
    this.paymentYearsCount,
    this.renewYearsCount,
    this.activitiesCostDetailes,
  });

  factory CalculatorResponse.fromJson(Map<String, dynamic> json) =>
      CalculatorResponse(
        totalCost: json["TotalCost"]?.toDouble(),
        costsInfo: json["CostsInfo"] == null
            ? []
            : List<CostsInfo>.from(
                json["CostsInfo"]!.map((x) => CostsInfo.fromJson(x))),
        detailedCostList: json["DetailedCostList"],
        paymentYearsCount: json["PaymentYearsCount"],
        renewYearsCount: json["RenewYearsCount"],
        activitiesCostDetailes: json["ActivitiesCostDetailes"] == null
            ? []
            : List<ActivitiesCostDetaile>.from(json["ActivitiesCostDetailes"]!
                .map((x) => ActivitiesCostDetaile.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TotalCost": totalCost,
        "CostsInfo": costsInfo == null
            ? []
            : List<dynamic>.from(costsInfo!.map((x) => x.toJson())),
        "DetailedCostList": detailedCostList,
        "PaymentYearsCount": paymentYearsCount,
        "RenewYearsCount": renewYearsCount,
        "ActivitiesCostDetailes": activitiesCostDetailes == null
            ? []
            : List<dynamic>.from(
                activitiesCostDetailes!.map((x) => x.toJson())),
      };
}

class ActivitiesCostDetaile {
  final String? refrence;
  final double? activtyCost;
  final double? cleaningCost;

  ActivitiesCostDetaile({
    this.refrence,
    this.activtyCost,
    this.cleaningCost,
  });

  factory ActivitiesCostDetaile.fromJson(Map<String, dynamic> json) =>
      ActivitiesCostDetaile(
        refrence: json["Refrence"],
        activtyCost: json["ActivtyCost"]?.toDouble(),
        cleaningCost: json["CleaningCost"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "Refrence": refrence,
        "ActivtyCost": activtyCost,
        "CleaningCost": cleaningCost,
      };
}

class CostsInfo {
  final String? costItemDescription;
  final int? costItemTypeId;
  final double? costItemValue;

  CostsInfo({
    this.costItemDescription,
    this.costItemTypeId,
    this.costItemValue,
  });

  factory CostsInfo.fromJson(Map<String, dynamic> json) => CostsInfo(
        costItemDescription: json["CostItemDescription"],
        costItemTypeId: json["CostItemTypeId"],
        costItemValue: json["CostItemValue"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "CostItemDescription": costItemDescription,
        "CostItemTypeId": costItemTypeId,
        "CostItemValue": costItemValue,
      };
}

class CleaningInfo {
  final dynamic contractNumber;
  final String? cleanOption;
  final dynamic contractOption;
  final String? cleanOptionName;
  final String? cleanOptionDesc;
  final dynamic cleanContractEndDate;

  CleaningInfo({
    this.contractNumber,
    this.cleanOption,
    this.contractOption,
    this.cleanOptionName,
    this.cleanOptionDesc,
    this.cleanContractEndDate,
  });

  factory CleaningInfo.fromJson(Map<String, dynamic> json) => CleaningInfo(
        contractNumber: json["contractNumber"],
        cleanOption: json["cleanOption"],
        contractOption: json["contractOption"],
        cleanOptionName: json["cleanOptionName"],
        cleanOptionDesc: json["cleanOptionDesc"],
        cleanContractEndDate: json["cleanContractEndDate"],
      );

  Map<String, dynamic> toJson() => {
        "contractNumber": contractNumber,
        "cleanOption": cleanOption,
        "contractOption": contractOption,
        "cleanOptionName": cleanOptionName,
        "cleanOptionDesc": cleanOptionDesc,
        "cleanContractEndDate": cleanContractEndDate,
      };
}

class ContractInfo {
  final ContractType? contractType;
  final TenancyContractInfo? tenancyContractInfo;
  final DeedInfo? deedInfo;
  final InvestmentContractInfo? investmentContractInfo;

  ContractInfo({
    this.contractType,
    this.tenancyContractInfo,
    this.deedInfo,
    this.investmentContractInfo,
  });

  factory ContractInfo.fromJson(Map<String, dynamic> json) => ContractInfo(
        contractType: json["contractType"] == null
            ? null
            : ContractType.fromJson(json["contractType"]),
        tenancyContractInfo: json["tenancyContractInfo"] == null
            ? null
            : TenancyContractInfo.fromMap(json["tenancyContractInfo"]),
        deedInfo: json["deedInfo"] == null
            ? null
            : DeedInfo.fromMap(json["deedInfo"]),
        investmentContractInfo: json["investmentContractInfo"] == null
            ? null
            : InvestmentContractInfo.fromMap(json["investmentContractInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "contractType": contractType?.toJson(),
        "tenancyContractInfo": tenancyContractInfo,
        "deedInfo": deedInfo,
        "investmentContractInfo": investmentContractInfo,
      };
}

class InvestmentContractInfo {
  String? investContractName;
  String? investmentContractNumber;
  ContractType? type;
  InvestmentContractInfo({
    this.investContractName,
    this.investmentContractNumber,
    this.type,
  });

  factory InvestmentContractInfo.fromMap(Map<String, dynamic> map) {
    return InvestmentContractInfo(
      investContractName: map['investContractName'] != null
          ? map['investContractName'] as String
          : null,
      investmentContractNumber: map['investmentContractNumber'] != null
          ? map['investmentContractNumber'] as String
          : null,
      type: map['type'] != null
          ? ContractType.fromJson(map['type'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DeedInfo {
  String? deedDate;
  String? deedNumber;
  DeedInfo({
    this.deedDate,
    this.deedNumber,
  });

  DeedInfo copyWith({
    String? deedDate,
    String? deedNumber,
  }) {
    return DeedInfo(
      deedDate: deedDate ?? this.deedDate,
      deedNumber: deedNumber ?? this.deedNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deedDate': deedDate,
      'deedNumber': deedNumber,
    };
  }

  factory DeedInfo.fromMap(Map<String, dynamic> map) {
    return DeedInfo(
      deedDate: map['deedDate'] != null ? map['deedDate'] as String : null,
      deedNumber:
          map['deedNumber'] != null ? map['deedNumber'] as String : null,
    );
  }
}

class TenancyContractInfo {
  String? contractEndDate;
  String? nationalId;
  String? tenancyContractNumber;
  String? versionNumber;
  TenancyContractInfo({
    this.contractEndDate,
    this.nationalId,
    this.tenancyContractNumber,
    this.versionNumber,
  });

  TenancyContractInfo copyWith({
    String? contractEndDate,
    String? nationalId,
    String? tenancyContractNumber,
    String? versionNumber,
  }) {
    return TenancyContractInfo(
      contractEndDate: contractEndDate ?? this.contractEndDate,
      nationalId: nationalId ?? this.nationalId,
      tenancyContractNumber:
          tenancyContractNumber ?? this.tenancyContractNumber,
      versionNumber: versionNumber ?? this.versionNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'contractEndDate': contractEndDate,
      'nationalId': nationalId,
      'tenancyContractNumber': tenancyContractNumber,
      'versionNumber': versionNumber,
    };
  }

  factory TenancyContractInfo.fromMap(Map<String, dynamic> map) {
    return TenancyContractInfo(
      contractEndDate: map['contractEndDate'] != null
          ? map['contractEndDate'] as String
          : null,
      nationalId:
          map['nationalId'] != null ? map['nationalId'] as String : null,
      tenancyContractNumber: map['tenancyContractNumber'] != null
          ? map['tenancyContractNumber'] as String
          : null,
      versionNumber:
          map['versionNumber'] != null ? map['versionNumber'] as String : null,
    );
  }
}

class ContractType {
  final String? id;
  final String? name;

  ContractType({
    this.id,
    this.name,
  });

  factory ContractType.fromJson(Map<String, dynamic> json) => ContractType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class GovernmentalApprovals {
  final List<String>? agencies;
  final String? description;

  GovernmentalApprovals({
    this.agencies,
    this.description,
  });

  factory GovernmentalApprovals.fromJson(Map<String, dynamic> json) =>
      GovernmentalApprovals(
        agencies: json["agencies"] == null
            ? []
            : List<String>.from(json["agencies"]!.map((x) => x)),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "agencies":
            agencies == null ? [] : List<dynamic>.from(agencies!.map((x) => x)),
        "description": description,
      };
}

class Location {
  final ContractType? municipality;
  final ContractType? subMunicipality;
  final ContractType? city;
  final ContractType? street;
  final ContractType? district;
  final ContractType? region;
  final String? mapNo;
  final String? landNo;
  final String? x;
  final String? y;

  Location({
    this.municipality,
    this.subMunicipality,
    this.city,
    this.street,
    this.district,
    this.region,
    this.mapNo,
    this.landNo,
    this.x,
    this.y,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        municipality: json["municipality"] == null
            ? null
            : ContractType.fromJson(json["municipality"]),
        subMunicipality: json["subMunicipality"] == null
            ? null
            : ContractType.fromJson(json["subMunicipality"]),
        city: json["city"] == null ? null : ContractType.fromJson(json["city"]),
        street: json["street"] == null
            ? null
            : ContractType.fromJson(json["street"]),
        district: json["district"] == null
            ? null
            : ContractType.fromJson(json["district"]),
        region: json["region"] == null
            ? null
            : ContractType.fromJson(json["region"]),
        mapNo: json["mapNo"],
        landNo: json["landNo"],
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
        "municipality": municipality?.toJson(),
        "subMunicipality": subMunicipality?.toJson(),
        "city": city?.toJson(),
        "street": street?.toJson(),
        "district": district?.toJson(),
        "region": region?.toJson(),
        "mapNo": mapNo,
        "landNo": landNo,
        "x": x,
        "y": y,
      };
}

class MainActivity {
  final ContractType? detailedActivity;
  final ContractType? isicActivity;
  final ContractType? mainActivity;
  final ContractType? facility;
  final ContractType? workerType;
  final double? area;
  final ContractType? accommodationType;
  final dynamic unitCount;

  MainActivity({
    this.detailedActivity,
    this.isicActivity,
    this.mainActivity,
    this.facility,
    this.workerType,
    this.area,
    this.accommodationType,
    this.unitCount,
  });

  factory MainActivity.fromJson(Map<String, dynamic> json) => MainActivity(
        detailedActivity: json["detailedActivity"] == null
            ? null
            : ContractType.fromJson(json["detailedActivity"]),
        isicActivity: json["isicActivity"] == null
            ? null
            : ContractType.fromJson(json["isicActivity"]),
        mainActivity: json["mainActivity"] == null
            ? null
            : ContractType.fromJson(json["mainActivity"]),
        facility: json["facility"] == null
            ? null
            : ContractType.fromJson(json["facility"]),
        workerType: json["workerType"] == null
            ? null
            : ContractType.fromJson(json["workerType"]),
        area: json["area"]?.toDouble(),
        accommodationType: json["accommodationType"] == null
            ? null
            : ContractType.fromJson(json["accommodationType"]),
        unitCount: json["unitCount"],
      );

  Map<String, dynamic> toJson() => {
        "detailedActivity": detailedActivity?.toJson(),
        "isicActivity": isicActivity?.toJson(),
        "mainActivity": mainActivity?.toJson(),
        "facility": facility?.toJson(),
        "workerType": workerType?.toJson(),
        "area": area,
        "accommodationType": accommodationType,
        "unitCount": unitCount,
      };
}

class Owner {
  final String? crNumber;
  final int? crType;
  final String? crTypeName;
  final String? name;

  Owner({
    this.crNumber,
    this.crType,
    this.crTypeName,
    this.name,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        crNumber: json["crNumber"],
        crType: json["crType"],
        crTypeName: json["crTypeName"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "crNumber": crNumber,
        "crType": crType,
        "crTypeName": crTypeName,
        "name": name,
      };
}

class SalamaInfo {
  final String? workFlow;
  final dynamic salamaReportNumber;
  final dynamic salamaBillNumber;
  final dynamic salamaPermitNumber;
  final String? documentDesc;
  final String? documentName;

  SalamaInfo({
    this.workFlow,
    this.salamaReportNumber,
    this.salamaBillNumber,
    this.salamaPermitNumber,
    this.documentDesc,
    this.documentName,
  });

  factory SalamaInfo.fromJson(Map<String, dynamic> json) => SalamaInfo(
        workFlow: json["workFlow"],
        salamaReportNumber: json["salamaReportNumber"],
        salamaBillNumber: json["salamaBillNumber"],
        salamaPermitNumber: json["salamaPermitNumber"],
        documentDesc: json["documentDesc"],
        documentName: json["documentName"],
      );

  Map<String, dynamic> toJson() => {
        "workFlow": workFlow,
        "salamaReportNumber": salamaReportNumber,
        "salamaBillNumber": salamaBillNumber,
        "salamaPermitNumber": salamaPermitNumber,
        "documentDesc": documentDesc,
        "documentName": documentName,
      };
}

class ShopInfo {
  final String? shopName;
  final int? shopNumber;
  final dynamic buildingNumber;
  final int? holesCount;
  final int? floorCount;
  final int? camerasNumber;
  final dynamic floorNumber;
  final bool? hasElevator;
  final bool? insidePetrolStation;
  final bool? insideMall;
  final ContractType? mall;
  final double? area;
  final List<BoardsInfo>? boardsInfo;

  ShopInfo({
    this.shopName,
    this.shopNumber,
    this.buildingNumber,
    this.holesCount,
    this.floorCount,
    this.camerasNumber,
    this.floorNumber,
    this.hasElevator,
    this.insidePetrolStation,
    this.insideMall,
    this.mall,
    this.area,
    this.boardsInfo,
  });

  factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
        shopName: json["shopName"],
        shopNumber: json["shopNumber"],
        buildingNumber: json["buildingNumber"],
        holesCount: json["holesCount"],
        floorCount: json["floorCount"],
        camerasNumber: json["camerasNumber"],
        floorNumber: json["floorNumber"],
        hasElevator: json["hasElevator"],
        insidePetrolStation: json["insidePetrolStation"],
        insideMall: json["insideMall"],
        area: json["area"]?.toDouble(),
        mall: json["mall"] == null ? null : ContractType.fromJson(json["mall"]),
        boardsInfo: json["boardsInfo"] == null
            ? []
            : List<BoardsInfo>.from(
                json["boardsInfo"]!.map((x) => BoardsInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "shopName": shopName,
        "shopNumber": shopNumber,
        "buildingNumber": buildingNumber,
        "holesCount": holesCount,
        "floorCount": floorCount,
        "camerasNumber": camerasNumber,
        "floorNumber": floorNumber,
        "hasElevator": hasElevator,
        "insidePetrolStation": insidePetrolStation,
        "insideMall": insideMall,
        "mall": mall,
        "area": area,
        "boardsInfo": boardsInfo == null
            ? []
            : List<dynamic>.from(boardsInfo!.map((x) => x.toJson())),
      };
}

class BoardsInfo {
  final ContractType? type;
  final double? area;

  BoardsInfo({
    this.type,
    this.area,
  });

  factory BoardsInfo.fromJson(Map<String, dynamic> json) => BoardsInfo(
        type: json["type"] == null ? null : ContractType.fromJson(json["type"]),
        area: json["area"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "type": type?.toJson(),
        "area": area,
      };
}

class Submitter {
  final String? identityNumber;
  final int? identityType;
  final String? identityTypeName;
  final String? name;
  final String? submitterType;

  Submitter({
    this.identityNumber,
    this.identityType,
    this.identityTypeName,
    this.name,
    this.submitterType,
  });

  factory Submitter.fromJson(Map<String, dynamic> json) => Submitter(
        identityNumber: json["identityNumber"],
        identityType: json["identityType"],
        identityTypeName: json["identityTypeName"],
        name: json["name"],
        submitterType: json["submitterType"],
      );

  Map<String, dynamic> toJson() => {
        "identityNumber": identityNumber,
        "identityType": identityType,
        "identityTypeName": identityTypeName,
        "name": name,
        "submitterType": submitterType,
      };
}

class WorkFlowStep {
  final String? stepId;
  final String? stepName;
  final int? sequenceId;
  final int? index;

  WorkFlowStep({
    this.stepId,
    this.stepName,
    this.sequenceId,
    this.index,
  });

  factory WorkFlowStep.fromJson(Map<String, dynamic> json) => WorkFlowStep(
        stepId: json["stepId"],
        stepName: json["stepName"],
        sequenceId: json["sequenceId"],
        index: json["index"],
      );

  Map<String, dynamic> toJson() => {
        "stepId": stepId,
        "stepName": stepName,
        "sequenceId": sequenceId,
        "index": index,
      };
}
