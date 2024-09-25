import 'package:equatable/equatable.dart';

class CleanContractsResponse extends Equatable {
  final List<CleanContractItem>? items;

  const CleanContractsResponse({
    this.items,
  });

  @override
  List<Object?> get props => [];
}

class CleanContractItem extends Equatable {
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

  const CleanContractItem({
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

  @override
  List<Object?> get props => [unifiedCleanContractNo, shopContractNo];
}
