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
      pictures: [
        Picture(
            url:
                "https://scth.scene7.com/is/image/scth/the-line-exhibition-riyadh-cover:crop-315x177?defaultImage=the-line-exhibition-riyadh-cover"),
        Picture(
            url:
                "https://scth.scene7.com/is/image/scth/the-line-exhibition-riyadh-cover:crop-315x177?defaultImage=the-line-exhibition-riyadh-cover"),
        Picture(
            url:
                "https://scth.scene7.com/is/image/scth/the-line-exhibition-riyadh-cover:crop-315x177?defaultImage=the-line-exhibition-riyadh-cover")
      ],
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
