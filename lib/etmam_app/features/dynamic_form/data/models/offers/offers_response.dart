import 'package:balady_plus/etmam_app/features/dynamic_form/data/models/offers/offers_item_model.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/offers_item.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/offers_response.dart';

class OffersResponseModel extends OffersResponse {
  OffersResponseModel({
    super.totalPageCount,
    super.totalItemCount,
    super.items,
  });

  factory OffersResponseModel.fromJson(Map<String, dynamic> json) =>
      OffersResponseModel(
        totalPageCount: json["totalPageCount"],
        totalItemCount: json["totalItemCount"],
        items: json["items"] == null
            ? []
            : List<OfferItem>.from(
                json["items"]!.map((x) => OfferItemModel.fromJson(x))),
      );
}
