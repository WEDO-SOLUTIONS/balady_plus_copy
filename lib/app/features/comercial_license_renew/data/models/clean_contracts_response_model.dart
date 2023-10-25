import '../../renew_commercial_license_exports.dart'
    show CleanContractsResponse, CleanContractItem;

class CleanContractsResponseModel extends CleanContractsResponse {
  const CleanContractsResponseModel({super.items});

  factory CleanContractsResponseModel.fromJson(Map<String, dynamic> json) =>
      CleanContractsResponseModel(
        items: json["result"] == null
            ? []
            : List<CleanContractItemModel>.from(
                json["result"]!.map((x) => CleanContractItemModel.fromJson(x))),
      );

  @override
  List<Object?> get props => [];
}

class CleanContractItemModel extends CleanContractItem {
  CleanContractItemModel({
    super.municipalityId,
    super.subMunicipalityId,
    super.unifiedCleanContractNo,
    super.shopContractNo,
    super.shopCrNo,
    super.isicCode,
    super.shopArea,
    super.shopName,
    super.contractStartDate,
    super.contractEndDate,
    super.carrierCrNo,
    super.carrierQualificationNo,
    super.shopInMall,
    super.mallContractNo,
    super.contractStatus,
    super.note,
    super.municipalityName,
    super.subMunicipalityName,
    super.contractStatusDesc,
  });

  factory CleanContractItemModel.fromJson(Map<String, dynamic> json) =>
      CleanContractItemModel(
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
}
