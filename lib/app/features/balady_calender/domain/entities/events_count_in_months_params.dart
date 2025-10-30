import 'package:balady_plus/app/features/balady_calender/domain/entities/events_common_params.dart';

class EventsCountInMonthsParams {
  EventsCommonParams commonParams;
  //////////////////////////////////////
  int year;

  EventsCountInMonthsParams({
    required this.commonParams,
    required this.year,
  });

  EventsCountInMonthsParams copyWith({
    EventsCommonParams? commonParams,
    int? year,
  }) =>
      EventsCountInMonthsParams(
        commonParams: commonParams ?? this.commonParams,
        year: year ?? this.year,
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = commonParams.toJson();
    data["year"] = year;
    return data;
  }
}
