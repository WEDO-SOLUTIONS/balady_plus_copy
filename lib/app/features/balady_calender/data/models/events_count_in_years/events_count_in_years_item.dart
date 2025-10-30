import 'package:equatable/equatable.dart';

class EventsCountInYearsItem extends Equatable {
  final int year;
  final int eventsCount;

  const EventsCountInYearsItem({required this.year, required this.eventsCount});

  factory EventsCountInYearsItem.fromJson(Map<String, dynamic> json) =>
      EventsCountInYearsItem(
        year: json['year'] ?? 0,
        eventsCount: json['eventsCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'year': year,
        'eventsCount': eventsCount,
      };

  @override
  List<Object?> get props => [year, eventsCount];
}
