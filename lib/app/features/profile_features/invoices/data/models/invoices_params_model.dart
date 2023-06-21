import 'package:equatable/equatable.dart';

import '../../../../../core/utils/utils_exports.dart' show SortType;

class InvoicesParamsModel extends Equatable {
  final int? identityNumber;
  final String? invoiceNumber;
  final String? requestNumber;
  final int page;
  final int size;
  final String? invoiceTypeId;
  final String? invoiceStatusId;
  final String? dueDate;
  final String? issueDate;
  final SortType sort;

  const InvoicesParamsModel({
    this.identityNumber,
    this.invoiceNumber,
    this.requestNumber,
    required this.page,
    required this.size,
    this.invoiceTypeId,
    this.invoiceStatusId,
    this.dueDate,
    this.issueDate,
    this.sort = SortType.desc,
  });

  Map<String, dynamic> toMap() {
    return {
      'identityNumber': identityNumber,
      'invoiceNumber': invoiceNumber,
      'requestNumber': requestNumber,
      'page': page,
      'size': size,
      'invoiceTypeId': invoiceTypeId,
      'invoiceStatusId': invoiceStatusId,
      'dueDate': dueDate,
      'issueDate': issueDate,
      'sort': sort,
    };
  }

  @override
  List<Object?> get props => [
        identityNumber,
        invoiceNumber,
        requestNumber,
        page,
        size,
        invoiceTypeId,
        invoiceStatusId,
        dueDate,
        issueDate,
        sort,
      ];
}
