import '../../commercial_license_exports.dart'
    show InvestmentContractResponse, InvestmentContractItem;

class InvestmentContractResponseModel extends InvestmentContractResponse {
  const InvestmentContractResponseModel({
    super.items,
  });

  factory InvestmentContractResponseModel.fromJson(Map<String, dynamic> json) =>
      InvestmentContractResponseModel(
        items: json["result"] == null
            ? []
            : List<InvestmentContractItemModel>.from(json["result"]!
                .map((x) => InvestmentContractItemModel.fromJson(x))),
      );
}

class InvestmentContractItemModel extends InvestmentContractItem {
  const InvestmentContractItemModel({
    super.statusName,
    super.typeName,
    super.municipalityName,
    super.submunicipalityName,
    super.siteContractId,
    super.contractTypeId,
    super.contractStatusId,
    super.contractName,
  });

  factory InvestmentContractItemModel.fromJson(Map<String, dynamic> json) =>
      InvestmentContractItemModel(
        statusName: json["statusName"],
        typeName: json["typeName"],
        municipalityName: json["municipality_name"],
        submunicipalityName: json["submunicipality_name"],
        siteContractId: json["site_contract_id"],
        contractTypeId: json["contract_type_id"],
        contractStatusId: json["contract_status_id"],
        contractName: json["contract_name"],
      );

  Map<String, dynamic> toJson() => {
        "statusName": statusName,
        "typeName": typeName,
        "municipality_name": municipalityName,
        "submunicipality_name": submunicipalityName,
        "site_contract_id": siteContractId,
        "contract_type_id": contractTypeId,
        "contract_status_id": contractStatusId,
        "contract_name": contractName,
      };

  @override
  List<Object?> get props =>
      [statusName, typeName, siteContractId, contractName];
}
