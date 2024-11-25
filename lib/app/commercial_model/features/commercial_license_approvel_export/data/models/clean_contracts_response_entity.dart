import 'package:equatable/equatable.dart';


class CleanContractsResponseEntity extends Equatable {
  final List<CleanContractItemEntity>? items;
  const CleanContractsResponseEntity({this.items});


  factory CleanContractsResponseEntity.fromJson(Map<String, dynamic> json) =>
      CleanContractsResponseEntity(
        items: json["result"] == null
            ? []
            : List<CleanContractItemEntity>.from(
                json["result"]!.map((x) => CleanContractItemEntity.fromJson(x))),
      );

  @override
  List<Object?> get props => [];
}

class CleanContractItemEntity extends Equatable {
  final String? municipalityId;
  final String? subMunicipalityId;
  final int? unifiedCleanContractNo;
  final String? shopContractNo;
  final int? shopCrNo;
  final int? isicCode;
  final double? shopArea;
  final String? shopName;
  final String? contractStartDate;
  final String? contractEndDate;
  final String? carrierCrNo;
  final String? carrierQualificationNo;
  final String? shopInMall;
  final String? mallContractNo;
  final int? contractStatus;
  final String? note;
  final String? municipalityName;
  final String? subMunicipalityName;
  final String? contractStatusDesc;
  
  CleanContractItemEntity({
   this.municipalityId,
   this.subMunicipalityId,
   this.unifiedCleanContractNo,
   this.shopContractNo,
   this.shopCrNo,
   this.isicCode,
   this.shopArea,
   this.shopName,
   this.contractStartDate,
   this.contractEndDate,
   this.carrierCrNo,
   this.carrierQualificationNo,
   this.shopInMall,
   this.mallContractNo,
   this.contractStatus,
   this.note,
   this.municipalityName,
   this.subMunicipalityName,
   this.contractStatusDesc,
  });

  factory CleanContractItemEntity.fromJson(Map<String, dynamic> json) =>
      CleanContractItemEntity(
        municipalityId: json["MunicipalityID"],
        subMunicipalityId: json["SubMunicipalityID"],
        unifiedCleanContractNo: json["UnifiedCleanContractNO"],
        shopContractNo: json["ShopContractNo"],
        shopCrNo: json["ShopCRNo"],
        isicCode: json["ISIC_CODE"],
        shopArea: json["ShopArea"]?.toDouble(),
        shopName: json["ShopName"],
        contractStartDate: json["ContractStartDate"],
        contractEndDate: json["ContractEndDate"],
        carrierCrNo: json["CarrierCRNo"],
        carrierQualificationNo: json["CarrierQualificationNo"],
        shopInMall: json["ShopInMall"],
        mallContractNo: json["MallContractNo"],
        contractStatus: json["ContractStatus"],
        note: json["Note"],
        municipalityName: json["MunicipalityName"],
        subMunicipalityName: json["SubMunicipalityName"],
        contractStatusDesc: json["ContractStatusDesc"],
      );

  Map<String, dynamic> toJson() => {
        "MunicipalityID": municipalityId,
        "SubMunicipalityID": subMunicipalityId,
        "UnifiedCleanContractNO": unifiedCleanContractNo,
        "ShopContractNo": shopContractNo,
        "ShopCRNo": shopCrNo,
        "ISIC_CODE": isicCode,
        "ShopArea": shopArea,
        "ShopName": shopName,
        "ContractStartDate": contractStartDate,
        "ContractEndDate": contractEndDate,
        "CarrierCRNo": carrierCrNo,
        "CarrierQualificationNo": carrierQualificationNo,
        "ShopInMall": shopInMall,
        "MallContractNo": mallContractNo,
        "ContractStatus": contractStatus,
        "Note": note,
        "MunicipalityName": municipalityName,
        "SubMunicipalityName": subMunicipalityName,
        "ContractStatusDesc": contractStatusDesc,
      };

  @override
  List<Object?> get props => [unifiedCleanContractNo, shopContractNo];
}
