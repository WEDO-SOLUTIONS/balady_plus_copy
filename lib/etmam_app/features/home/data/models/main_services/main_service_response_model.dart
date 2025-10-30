import 'package:balady_plus/etmam_app/features/home/domain/entities/main_services/main_services_response.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show MainServiceItemModel, MainServiceItems;

class MainServicesResponseModel extends MainServiceResponse {
  MainServicesResponseModel(
      {super.items, super.totalItemCount, super.totalPageCount});

  factory MainServicesResponseModel.fromMap(Map<String, dynamic> json) =>
      MainServicesResponseModel(
          totalItemCount: json["totalItemCount"],
          totalPageCount: json["totalPageCount"],
          items: json["items"] != null
              ? List<MainServiceItems>.from(
                  json["items"].map((x) => MainServiceItemModel.fromMap(x)))
              : null);
}
