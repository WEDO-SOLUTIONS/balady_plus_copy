import 'package:equatable/equatable.dart';


import 'calendar_event.dart';


class Events extends Equatable {
  final int? totalItemsCount;
  final int? pageSize;
  final int? totalPages;
  final List<CalendarEvent>? calendarEvents;

  const Events({
    this.totalItemsCount,
    this.pageSize,
    this.totalPages,
    this.calendarEvents,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
    totalItemsCount: json['totalItemsCount'] as int?,
    pageSize: json['pageSize'] as int?,
    totalPages: json['totalPages'] as int?,
    calendarEvents: (json['calendarEvents'] as List<dynamic>?)
        ?.map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>))
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
