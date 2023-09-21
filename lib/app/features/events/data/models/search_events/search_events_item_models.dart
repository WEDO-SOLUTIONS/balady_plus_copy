import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_item.dart';

class SearchEventsItemModel extends SearchEventsItem {
  SearchEventsItemModel({
    super.category,
    super.city,
    super.endDate,
    super.eventName,
    super.id,
    super.locationX,
    super.locationY,
    super.logoImage,
    super.startDate,
  });

  factory SearchEventsItemModel.fromMap(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateString) {
      if (dateString != null && dateString.isNotEmpty) {
        try {
          final parts = dateString.split('/');
          if (parts.length == 3) {
            final month = int.tryParse(parts[0]);
            final day = int.tryParse(parts[1]);
            final year = int.tryParse(parts[2]);

            if (month != null && day != null && year != null) {
              return DateTime(year, month, day);
            }
          }
        } catch (e) {
          throw ServerException("errors_server_error_2");
        }
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
    );
  }
}
