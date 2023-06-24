import 'package:balady_plus/app/features/retrive_car/data/model/vehicle_item_model.dart';

import '../../domain/entities/vehicle_response.dart';

class VehicleResponseModel extends VehicleResponse {
  VehicleResponseModel({super.items, super.totalCount});
  factory VehicleResponseModel.fromMap(Map<String, dynamic> json) =>
      VehicleResponseModel(
          totalCount: json["totalCount"],
          items: json["items"] != null
              ? List<VehicleItemModel>.from(
                  json["items"].map((x) => VehicleItemModel.fromJson(x)))
              : null);

  @override
  List<Object?> get props => [];
}
