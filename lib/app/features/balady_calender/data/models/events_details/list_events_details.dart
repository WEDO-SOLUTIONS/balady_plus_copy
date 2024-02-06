import 'package:equatable/equatable.dart';


import 'calendar_event_item.dart';


class EventsDetails extends Equatable {
  final int? totalItemsCount;
  final int? pageSize;
  final int? totalPages;
  final List<CalendarEventItem>? calendarEvents;

  const EventsDetails({
    this.totalItemsCount,
    this.pageSize,
    this.totalPages,
    this.calendarEvents,
  });

  factory EventsDetails.fromJson(Map<String, dynamic> json) => EventsDetails(
    totalItemsCount: json['totalItemsCount'] as int?,
    pageSize: json['pageSize'] as int?,
    totalPages: json['totalPages'] as int?,
    calendarEvents: (json['calendarEvents'] as List<dynamic>?)
        ?.map((e) => CalendarEventItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'totalItemsCount': totalItemsCount,
    'pageSize': pageSize,
    'totalPages': totalPages,
    'calendarEvents': calendarEvents?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props {
    return [
      totalItemsCount,
      pageSize,
      totalPages,
      calendarEvents,
    ];
  }
}
