import 'package:balady_plus/app/features/events/data/models/search_events/search_events_item_models.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_item.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_response.dart';

class SearchEventResponseModel extends SearchEventsResponse {
  SearchEventResponseModel({super.items});

  factory SearchEventResponseModel.fromMap(Map<String, dynamic> json) => SearchEventResponseModel(
      items: json["items"] != null
          ? List<SearchEventsItem>.from(json["items"].map((x) => SearchEventsItemModel.fromMap(x)))
          : null);
}
