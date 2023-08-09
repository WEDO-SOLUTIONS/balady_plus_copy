import 'package:equatable/equatable.dart';

import '../../../../../core/utils/common_functions.dart';

class CRMRequestsParamsModel extends Equatable {
  final String id;
  final String mobileNumber;

  const CRMRequestsParamsModel({required this.id, required this.mobileNumber});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (CommonProperties.userInfo!.idNo!.startsWith("1"))
        "NationalID": "${CommonProperties.userInfo!.idNo}"
      else
        "IqamaID": "${CommonProperties.userInfo!.idNo}",
      'mobileNumber': mobileNumber,
    };
  }

  @override
  List<Object?> get props => [
        id,
        mobileNumber,
      ];
}
