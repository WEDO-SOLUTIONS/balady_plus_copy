import 'package:equatable/equatable.dart';

import '../../../../../core/utils/utils_exports.dart' show SortType;

class InvoicesParamsModel extends Equatable {
  final String? unifiedNationalNumber;
  final String? identityNumber;
  final String? invoiceId;
  final String? requestNumber;
  final int page;
  final int size;
  final String? productId;
  final String? requestTypeId;
  final String? invoiceStatusId;
  final String? sadadDate;
  final String? creationDate;
  final SortType sort;

  const InvoicesParamsModel({
    this.unifiedNationalNumber,
    this.identityNumber,
    this.invoiceId,
    this.requestNumber,
    required this.page,
    required this.size,
    this.productId,
    this.requestTypeId,
    this.invoiceStatusId,
    this.sadadDate,
    this.creationDate,
    this.sort = SortType.desc,
  });

  Map<String, dynamic> toMap() {
    return {
      'unifiedNationalNumber': unifiedNationalNumber,
      'identityNumber': identityNumber,
      'page': page,
      'size': size,
      'requestNumber': requestNumber,
      'invoiceId': invoiceId,
      'productId': productId,
      'requestTypeId': requestTypeId,
      'invoiceStatusId': invoiceStatusId,
      'sadadDate': sadadDate,
      'creationDate': creationDate,
      'sort': [
        {
          'filed': "9",
          "type": sort.value,
        },
      ],
    };
  }

  @override
  List<Object?> get props => [
        unifiedNationalNumber,
        identityNumber,
        invoiceId,
        requestNumber,
        page,
        size,
        productId,
        requestTypeId,
        invoiceStatusId,
        sadadDate,
        creationDate,
        sort,
      ];
}
