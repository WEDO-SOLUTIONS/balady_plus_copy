import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show SubServiceItemModel, SubServiceItems, SubServiceResponse;

class SubServicesResponseModel extends SubServiceResponse {
  SubServicesResponseModel(
      {super.items, super.totalItemCount, super.totalPageCount});

  factory SubServicesResponseModel.fromMap(Map<String, dynamic> json) =>
      SubServicesResponseModel(
          totalItemCount: json["totalItemCount"],
          totalPageCount: json["totalPageCount"],
          items: json["items"] != null
              ? List<SubServiceItems>.from(
                  json["items"].map((x) => SubServiceItemModel.fromMap(x)))
              : null);
}
