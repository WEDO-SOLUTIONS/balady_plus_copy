import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CityItemModel, CityResponse;

class CityResponseModel extends CityResponse {
  CityResponseModel({super.items, super.totalItemCount, super.totalPageCount});

  factory CityResponseModel.fromMap(
          Map<String, dynamic> json) =>
      CityResponseModel(
          totalItemCount: json["totalItemCount"],
          totalPageCount: json["totalPageCount"],
          items: json["items"] != null
              ? List<CityItemModel>.from(
                  json["items"].map((x) => CityItemModel.fromMap(x)))
              : null);
}
