import 'package:balady_plus/app/features/ekram/domain/entities/trip_location_response.dart';
import 'package:equatable/equatable.dart';

class TripLocationsResponseModel extends TripLocationsResponse {
  const TripLocationsResponseModel({super.items});

  factory TripLocationsResponseModel.fromMap(Map<String, dynamic> json) =>
      TripLocationsResponseModel(
        items: json["result"] == null
            ? null
            : List<TripLocationItemModel>.from(
                json["result"].map((x) => TripLocationItemModel.fromMap(x))),
      );
}

class TripLocationItemModel extends TripLocationItem {
  const TripLocationItemModel({super.lastX, super.lastY});

  factory TripLocationItemModel.fromMap(Map<String, dynamic> json) =>
      TripLocationItemModel(
        lastX: json["lastX"],
        lastY: json["lastY"],
      );
}
