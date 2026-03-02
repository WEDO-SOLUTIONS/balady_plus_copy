import 'package:balady_plus/app/features/events/domain/entities/events_details/event_details_item.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/events_location.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/events_picture.dart';
import 'package:intl/intl.dart';

class EventsDetailsItemModel extends EventDetailsResponse {
  EventsDetailsItemModel(
      {super.audience,
      super.category,
      super.city,
      super.description,
      super.endDate,
      super.endTime,
      super.name,
      super.feesType,
      super.id,
      super.logoUrl,
      super.season,
      super.startDate,
      super.startTime,
      super.location,
      super.pictures,
      super.ticketUrl,
      super.fees});

  factory EventsDetailsItemModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateString) {
      if (dateString != null && dateString.isNotEmpty) {
        DateTime date = DateFormat("MM/dd/yyyy").parse(dateString);
        return date;
      }
      return null;
    }

    return EventsDetailsItemModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      category: json["category"],
      city: json["city"],
      startDate: json["startDate"] != null ? parseDate(json["startDate"]) : null,
      endDate: json["endDate"] != null ? parseDate(json["endDate"]) : null,
      startTime: json["startTime"],
      endTime: json["endTime"],
      logoUrl: json["logoURL"],
      feesType: json["feesType"],
      season: json["season"],
      audience: json["audience"],
      location: json["location"] == null ? null : Location.fromJson(json["location"]),
      ticketUrl: json["ticketURL"],
      fees: json["fees"],
      pictures: json["pictures"] == null ? [] : List<Picture>.from(json["pictures"]!.map((x) => Picture.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "category": category,
        "city": city,
        "startDate": startDate,
        "endDate": endDate,
        "startTime": startTime,
        "endTime": endTime,
        "logoURL": logoUrl,
        "feesType": feesType,
        "season": season,
        "audience": audience,
        "location": location?.toJson(),
        "ticketURL": ticketUrl,
        "pictures": pictures == null ? [] : List<dynamic>.from(pictures!.map((x) => x.toJson())),
      };
}
