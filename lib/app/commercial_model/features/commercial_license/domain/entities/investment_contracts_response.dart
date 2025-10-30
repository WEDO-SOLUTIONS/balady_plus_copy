import 'package:equatable/equatable.dart';

class InvestmentContractResponse extends Equatable {
  final List<InvestmentContractItem>? items;

  const InvestmentContractResponse({
    this.items,
  });

  @override
  List<Object?> get props => [];
}

class InvestmentContractItem extends Equatable {
  final String? statusName;
  final String? typeName;
  final String? municipalityName;
  final String? submunicipalityName;
  final String? siteContractId;
  final int? contractTypeId;
  final int? contractStatusId;
  final String? contractName;

  const InvestmentContractItem({
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
}
