import 'package:balady_plus/app/features/calendar/domain/entities/search_calendar/search_calendar_item.dart';

class SearchCalendarResponse {
  SearchCalendarResponse({this.items});

  List<SearchCalendarItem>? items;
}
