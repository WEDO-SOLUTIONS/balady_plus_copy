import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ProviderResponse, ProviderItemModel;

class ProvidersResponseModel extends ProviderResponse {
  ProvidersResponseModel(
      {super.items, super.totalItemCount, super.totalPageCount});

  factory ProvidersResponseModel.fromMap(Map<String, dynamic> json) =>
      ProvidersResponseModel(
          totalItemCount: json["totalItemCount"],
          totalPageCount: json["totalPageCount"],
          items: json["items"] != null
              ? List<ProviderItemModel>.from(
                  json["items"].map((x) => ProviderItemModel.fromMap(x)))
              : null);
}
