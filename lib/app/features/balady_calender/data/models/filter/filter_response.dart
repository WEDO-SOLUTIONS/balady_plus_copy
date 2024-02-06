import 'package:equatable/equatable.dart';

import 'filter_item.dart';

class Filter extends Equatable {
  final List<FilterItem>? data;
  final List<String>? errorList;
  final int? statusCode;
  final String? statusName;
  final int? itemsCount;
  final String? httpRequestId;

  const Filter({
    this.data,
    this.errorList,
    this.statusCode,
    this.statusName,
    this.itemsCount,
    this.httpRequestId,
  });

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => FilterItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        errorList: json['errorList'] as List<String>?,
        statusCode: json['statusCode'] as int?,
        statusName: json['statusName'] as String?,
        itemsCount: json['itemsCount'] as int?,
        httpRequestId: json['httpRequestId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'data': data?.map((e) => e.toJson()).toList(),
        'errorList': errorList,
        'statusCode': statusCode,
        'statusName': statusName,
        'itemsCount': itemsCount,
        'httpRequestId': httpRequestId,
      };

  @override
  List<Object?> get props {
    return [
      data,
      errorList,
      statusCode,
      statusName,
      itemsCount,
      httpRequestId,
    ];
  }
}
