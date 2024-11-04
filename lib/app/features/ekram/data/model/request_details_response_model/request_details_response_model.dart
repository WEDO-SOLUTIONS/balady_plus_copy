import 'data.dart';
import 'status_details.dart';

class RequestDetailsResponseModel {
  StatusDetails? statusDetails;
  Data? data;

  RequestDetailsResponseModel({this.statusDetails, this.data});

  factory RequestDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return RequestDetailsResponseModel(
      statusDetails: json['statusDetails'] == null
          ? null
          : StatusDetails.fromJson(
              json['statusDetails'] as Map<String, dynamic>),
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'statusDetails': statusDetails?.toJson(),
        'data': data?.toJson(),
      };
}
