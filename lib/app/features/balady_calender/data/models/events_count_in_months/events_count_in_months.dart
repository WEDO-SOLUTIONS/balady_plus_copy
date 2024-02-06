import 'package:equatable/equatable.dart';

class EventsCountInMonths extends Equatable {
  final List<EventsCountInMonths>? monthsEventsCount;

  const EventsCountInMonths({this.monthsEventsCount});

  factory EventsCountInMonths.fromJson(Map<String, dynamic> json) => EventsCountInMonths(
    monthsEventsCount: (json['monthsEventsCount'] as List<dynamic>?)
        ?.map(
            (e) => EventsCountInMonths.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'monthsEventsCount': monthsEventsCount?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [monthsEventsCount];
}

