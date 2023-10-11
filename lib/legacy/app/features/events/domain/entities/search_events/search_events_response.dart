import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_item.dart';

class SearchEventsResponse {
  SearchEventsResponse({this.items});

  List<SearchEventsItem>? items;
}
