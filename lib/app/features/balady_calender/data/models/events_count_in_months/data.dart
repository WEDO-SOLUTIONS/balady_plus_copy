import 'package:equatable/equatable.dart';

import 'first_month_event.dart';
import 'events_count_in_months.dart';

class Data extends Equatable {
  final List<FirstMonthEvent>? firstMonthEvents;
  final List<EventsCountInMonths>? monthsEventsCount;

  const Data({this.firstMonthEvents, this.monthsEventsCount});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        firstMonthEvents: (json['firstMonthEvents'] as List<dynamic>?)
            ?.map((e) => FirstMonthEvent.fromJson(e as Map<String, dynamic>))
            .toList(),
        monthsEventsCount: (json['monthsEventsCount'] as List<dynamic>?)
            ?.map(
                (e) => EventsCountInMonths.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'firstMonthEvents': firstMonthEvents?.map((e) => e.toJson()).toList(),
        'monthsEventsCount': monthsEventsCount?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [firstMonthEvents, monthsEventsCount];
}
