import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_item.dart';
import 'package:intl/intl.dart';

class SearchEventsItemModel extends SearchEventsItem {
  SearchEventsItemModel(
      {super.category,
      super.city,
      super.endDate,
      super.eventName,
      super.id,
      super.locationX,
      super.locationY,
      super.logoImage,
      super.startDate,
      super.feesType});

  factory SearchEventsItemModel.fromMap(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateString) {
      if (dateString != null && dateString.isNotEmpty) {
        DateTime date = DateFormat("MM/dd/yyyy").parse(dateString);
        return date;
      }
      return null;
    }

    return SearchEventsItemModel(
        id: json["id"],
        eventName: json["name"],
        category: json["category"],
        city: json["city"],
        startDate: parseDate(json["startDate"]),
        endDate: parseDate(json["endDate"]),
        logoImage: json["logoURL"],
        locationX: json["location"]?["x"],
        locationY: json["location"]?["y"],
        feesType: json["feesType"]);
  }
}
