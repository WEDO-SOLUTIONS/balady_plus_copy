import 'package:intl/intl.dart';

import '../../../domain/entities/search_calendar/search_calendar_item.dart';

class SearchCalendarItemModel extends SearchCalendarItem {
  SearchCalendarItemModel({
    super.description,
    super.logoURL,
    super.endDate,
    super.name,
    super.id,
    super.timeToStartInDays,
    super.type,
    super.startDate,
  });

  factory SearchCalendarItemModel.fromMap(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateString) {
      if (dateString != null && dateString.isNotEmpty) {
        DateTime date = DateFormat("MM/dd/yyyy").parse(dateString);
        return date;
      }
      return null;
    }

    return SearchCalendarItemModel(
      id: json["id"],
      name: json["name"],
      description: json["category"],
      timeToStartInDays: json["timeToStartInDays"],
      startDate: parseDate(json["startDate"]),
      endDate: parseDate(json["endDate"]),
      logoURL: json["logoURL"],
      type: json["type"],
    );
  }
}
