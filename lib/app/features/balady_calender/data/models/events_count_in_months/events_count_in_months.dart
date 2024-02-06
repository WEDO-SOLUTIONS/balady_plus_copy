import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_months/months_events_count.dart';
import 'package:equatable/equatable.dart';

class EventsCountInMonths extends Equatable {
  final List<MonthsEventsCount>? monthsEventsCount;

  const EventsCountInMonths({this.monthsEventsCount});

  factory EventsCountInMonths.fromJson(Map<String, dynamic> json) =>
      EventsCountInMonths(
        monthsEventsCount: (json['monthsEventsCount'] as List<dynamic>?)
            ?.map((e) => MonthsEventsCount.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'monthsEventsCount': monthsEventsCount?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [monthsEventsCount];
}
