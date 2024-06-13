import 'package:equatable/equatable.dart';

import 'calendar_event_item.dart';

class EventsDetails extends Equatable {
  final int totalItemsCount;
  // final int? pageSize;
  final int totalPageCount;
  final List<CalendarEventItem>? calendarEvents;

  const EventsDetails({
    required this.totalItemsCount,
    // this.pageSize,
    required this.totalPageCount,
    this.calendarEvents,
  });

  factory EventsDetails.fromJson(Map<String, dynamic> json) => EventsDetails(
        totalItemsCount: json['totalItemCount'] ?? 0,
        // pageSize: json['pageSize'] as int?,
        totalPageCount: json['totalPageCount'] ?? 0,
        calendarEvents: (json['items'] as List<dynamic>?)
            ?.map((e) => CalendarEventItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'totalItemsCount': totalItemsCount,
        // 'pageSize': pageSize,
        'totalPages': totalPageCount,
        'calendarEvents': calendarEvents?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props {
    return [
      totalItemsCount,
      // pageSize,
      totalPageCount,
      calendarEvents,
    ];
  }
}
