import 'package:equatable/equatable.dart';

import 'events_count_in_years_item.dart';

class EventsCountInYears extends Equatable {
  final List<EventsCountInYearsItem>? data;
  final List<String>? errorList;
  final int? statusCode;
  final String? statusName;
  final int? itemsCount;
  final String? httpRequestId;

  const EventsCountInYears({
    this.data,
    this.errorList,
    this.statusCode,
    this.statusName,
    this.itemsCount,
    this.httpRequestId,
  });

  factory EventsCountInYears.fromJson(Map<String, dynamic> json) =>
      EventsCountInYears(
        data: (json['data'] as List<dynamic>?)
            ?.map((e) =>
                EventsCountInYearsItem.fromJson(e as Map<String, dynamic>))
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
