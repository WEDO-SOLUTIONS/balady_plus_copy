import 'package:equatable/equatable.dart';

import '../../municipal_advisor_exports.dart';

class ContractEntity extends Equatable {
  final String contractTypeId;
  final String contractTypeName;
  final List<ContractOptionEntity> contractOptions;

  const ContractEntity({
    required this.contractTypeId,
    required this.contractTypeName,
    required this.contractOptions,
  });

  @override
  List<Object> get props => [
        contractTypeId,
        contractTypeName,
        contractOptions,
      ];
}
