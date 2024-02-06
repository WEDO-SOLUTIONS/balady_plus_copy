import 'package:equatable/equatable.dart';

class EventsCountInYearsItem extends Equatable {
  final int? year;
  final int? eventsCount;

  const EventsCountInYearsItem({this.year, this.eventsCount});

  factory EventsCountInYearsItem.fromJson(Map<String, dynamic> json) =>
      EventsCountInYearsItem(
        year: json['year'] as int?,
        eventsCount: json['eventsCount'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'year': year,
        'eventsCount': eventsCount,
      };

  @override
  List<Object?> get props => [year, eventsCount];
}
