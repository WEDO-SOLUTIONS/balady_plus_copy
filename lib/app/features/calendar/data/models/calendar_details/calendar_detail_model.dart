import 'package:intl/intl.dart';

import '../../../domain/entities/search_calendar/calendar_details_response.dart';

class CalendarDetailsModel extends CalendarDetailsResponse {
  CalendarDetailsModel({
    super.description,
    super.endDate,
    super.name,
    super.id,
    super.logoUrl,
    super.startDate,
    super.pictures,
  });

  factory CalendarDetailsModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateString) {
      if (dateString != null && dateString.isNotEmpty) {
        DateTime date = DateFormat("MM/dd/yyyy").parse(dateString);
        return date;
      }
      return null;
    }

    return CalendarDetailsModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      startDate:
          json["startDate"] != null ? parseDate(json["startDate"]) : null,
      endDate: json["endDate"] != null ? parseDate(json["endDate"]) : null,
      logoUrl: json["logoURL"],
      pictures: json["pictures"] == null
          ? []
          : List<Picture>.from(
              json["pictures"]!.map((x) => Picture.fromJson(x))),
    );
  }
}

class PictureModel extends Picture {
  PictureModel({
    super.caption,
    super.url,
  });

  factory PictureModel.fromJson(Map<String, dynamic> json) => PictureModel(
        caption: json["caption"],
        url: json["url"],
      );
}
