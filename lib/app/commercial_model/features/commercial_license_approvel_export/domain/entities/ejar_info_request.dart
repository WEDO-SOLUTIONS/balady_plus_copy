// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class EjarInfoRequest extends Equatable {
  final String? iqamaNumber;
  final String? nationalId;
  final String? tenancyContractNumber;
  final String? versionNumber;
  const EjarInfoRequest({
    this.iqamaNumber,
    this.nationalId,
    this.tenancyContractNumber,
    this.versionNumber,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (iqamaNumber != null && iqamaNumber!.isNotEmpty)
        'IqamaNumber': iqamaNumber,
      if (nationalId != null && nationalId!.isNotEmpty)
        'NationalId': nationalId,
      'TenancyContractNumber': tenancyContractNumber,
      'VersionNumber': versionNumber,
    };
  }

  String? getId() {
    if (nationalId?.isNotEmpty ?? false) return nationalId ?? "";

    if (iqamaNumber?.isNotEmpty ?? false) return iqamaNumber ?? "";
  }

  @override
  List<Object?> get props =>
      [iqamaNumber, nationalId, tenancyContractNumber, versionNumber];

  EjarInfoRequest copyWith({
    String? iqamaNumber,
    String? nationalId,
    String? tenancyContractNumber,
    String? versionNumber,
  }) {
    return EjarInfoRequest(
      iqamaNumber: iqamaNumber ?? this.iqamaNumber,
      nationalId: nationalId ?? this.nationalId,
      tenancyContractNumber:
          tenancyContractNumber ?? this.tenancyContractNumber,
      versionNumber: versionNumber ?? this.versionNumber,
    );
  }
}
