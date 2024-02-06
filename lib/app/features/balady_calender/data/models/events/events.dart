import 'package:equatable/equatable.dart';

import 'data.dart';

class Events extends Equatable {
  final Data? data;
  final List<String>? errorList;
  final int? statusCode;
  final String? statusName;
  final int? itemsCount;
  final String? httpRequestId;

  const Events({
    this.data,
    this.errorList,
    this.statusCode,
    this.statusName,
    this.itemsCount,
    this.httpRequestId,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
        errorList: json['errorList'] as List<String>?,
        statusCode: json['statusCode'] as int?,
        statusName: json['statusName'] as String?,
        itemsCount: json['itemsCount'] as int?,
        httpRequestId: json['httpRequestId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
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
