import 'package:equatable/equatable.dart';


class InvestmentContractResponseModel {
  final List<InvestmentContractItemModel>? items;

  const InvestmentContractResponseModel({
    this.items,
  });

  @override
  List<Object?> get props => [];

  factory InvestmentContractResponseModel.fromJson(Map<String, dynamic> json) =>
      InvestmentContractResponseModel(
        items: json["result"] == null
            ? []
            : List<InvestmentContractItemModel>.from(json["result"]!
                .map((x) => InvestmentContractItemModel.fromJson(x))),
      );
}

class InvestmentContractItemModel extends Equatable{
  final String? statusName;
  final String? typeName;
  final String? municipalityName;
  final String? submunicipalityName;
  final String? siteContractId;
  final int? contractTypeId;
  final int? contractStatusId;
  final String? contractName;

  const InvestmentContractItemModel({
    this.statusName,
    this.typeName,
    this.municipalityName,
    this.submunicipalityName,
    this.siteContractId,
    this.contractTypeId,
    this.contractStatusId,
    this.contractName,
  });

  @override
  List<Object?> get props =>
      [statusName, typeName, siteContractId, contractName];

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


}
