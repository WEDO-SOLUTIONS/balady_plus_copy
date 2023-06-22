import 'package:equatable/equatable.dart';

class DashboardStatisticsParamsModel extends Equatable {
  final int? productId;
  final String? unifiedNationalNumber;
  final String? identityNumber;
  final int mainCardId;

  const DashboardStatisticsParamsModel({
    this.productId,
    this.unifiedNationalNumber,
    this.identityNumber,
    required this.mainCardId,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'mainCardId': mainCardId,
    };
    if (productId != null) {
      map['productId'] = productId;
    }
    if (unifiedNationalNumber != null) {
      map['unifiedNationalNumber'] = unifiedNationalNumber;
    }
    if (identityNumber != null) {
      map['identityNumber'] = identityNumber;
    }
    return map;
  }

  @override
  List<Object?> get props => [
        productId,
        unifiedNationalNumber,
        identityNumber,
        mainCardId,
      ];
}
