import 'package:balady_plus/app/features/calendar/data/models/search_calendar/search_calendars_item_models.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_response.dart';

import '../../../domain/entities/search_calendar/search_calendar_response.dart';

class SearchCalendarResponseModel extends SearchCalendarResponse {
  SearchCalendarResponseModel({super.items});

  factory SearchCalendarResponseModel.fromMap(Map<String, dynamic> json) =>
      SearchCalendarResponseModel(
          items: json["items"] != null
              ? List<SearchCalendarItemModel>.from(
                  json["items"].map((x) => SearchCalendarItemModel.fromMap(x)))
              : null);
}
