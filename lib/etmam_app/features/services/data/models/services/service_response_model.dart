import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show ServiceResponse, ServiceItems, ServiceItemModel;

class ServicesResponseModel extends ServiceResponse {
  ServicesResponseModel(
      {super.items, super.totalItemCount, super.totalPageCount});

  factory ServicesResponseModel.fromMap(Map<String, dynamic> json) =>
      ServicesResponseModel(
          totalItemCount: json["totalItemCount"],
          totalPageCount: json["totalPageCount"],
          items: json["items"] != null
              ? List<ServiceItems>.from(
                  json["items"].map((x) => ServiceItemModel.fromMap(x)))
              : null);
}
