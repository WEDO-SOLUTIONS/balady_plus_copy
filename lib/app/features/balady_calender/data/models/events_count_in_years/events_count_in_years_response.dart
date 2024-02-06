import 'package:equatable/equatable.dart';

import 'events_count_in_years_item.dart';

class EventsCountInYears extends Equatable {
  final List<EventsCountInYearsItem>? eventsCountInYearsItem;

  const EventsCountInYears({
    this.eventsCountInYearsItem,
  });

  factory EventsCountInYears.fromJson(Map<String, dynamic> json) =>
      EventsCountInYears(
        eventsCountInYearsItem: (json['data'] as List<dynamic>?)
            ?.map((e) =>
                EventsCountInYearsItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'data': eventsCountInYearsItem?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props {
    return [
      eventsCountInYearsItem,
    ];
  }
}
