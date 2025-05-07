import 'package:freezed_annotation/freezed_annotation.dart';

part 'parking_store_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ParkingStoreModel {
  final DateTime dateTime;
  final List<String> imagesPaths;
  final String comment;
  final double lat;
  final double lon;
  final String address;

  ParkingStoreModel({
    required this.dateTime,
    required this.imagesPaths,
    required this.comment,
    required this.lat,
    required this.lon,
    required this.address,
  });

  factory ParkingStoreModel.fromJson(Map<String, dynamic> json) => _$ParkingStoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParkingStoreModelToJson(this);
}
