import 'dart:convert';

import 'package:balady_plus/app/features/balady_calender/domain/entities/events_count_in_months_params.dart';

String eventsParamsToJson(EventsDetailsParams data) =>
    json.encode(data.toJson());

class EventsDetailsParams {
  EventsCountInMonthsParams commonParams;
  //////////////////////////////////////
  int page;
  int size;

  EventsDetailsParams({
    required this.commonParams,
    this.page = 0,
    this.size = 12,
  });

  EventsDetailsParams copyWith({
    EventsCountInMonthsParams? commonParams,
    int? page,
    int? size,
  }) =>
      EventsDetailsParams(
        commonParams: commonParams ?? this.commonParams,
        page: page ?? this.page,
        size: size ?? this.size,
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = commonParams.toJson();
    data["page"] = page;
    data["size"] = size;
    return data;
  }
}
