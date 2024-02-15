import 'package:equatable/equatable.dart';

List<MonthsEventsCount> monthsListFromMap(List data) => data
    .map((e) => MonthsEventsCount.fromJson(e as Map<String, dynamic>))
    .toList();

class MonthsEventsCount extends Equatable {
  final int? month;
  final int? eventsCount;

  const MonthsEventsCount({this.month, this.eventsCount});

  factory MonthsEventsCount.fromJson(Map<String, dynamic> json) {
    return MonthsEventsCount(
      month: json['month'] as int?,
      eventsCount: json['eventsCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'month': month,
        'eventsCount': eventsCount,
      };

  @override
  List<Object?> get props => [month, eventsCount];
}
