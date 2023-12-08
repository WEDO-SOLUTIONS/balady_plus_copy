import 'package:balady_plus/etmam_app/features/home/data/models/ads/ad_item_model.dart';
import 'package:balady_plus/etmam_app/features/home/domain/entities/ads/ads_response.dart';

class AdResponseModel extends AdsResponse {
  AdResponseModel({super.items, super.totalItemCount, super.totalPageCount});

  factory AdResponseModel.fromMap(Map<String, dynamic> json) => AdResponseModel(
      totalItemCount: json["totalItemCount"],
      totalPageCount: json["totalPageCount"],
      items: json["items"] != null
          ? List<AdItemModel>.from(
              json["items"].map((x) => AdItemModel.fromMap(x)))
          : null);
}
