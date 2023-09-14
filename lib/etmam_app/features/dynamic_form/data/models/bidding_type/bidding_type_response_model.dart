import 'package:balady_plus/etmam_app/features/dynamic_form/data/models/bidding_type/bidding_service_item_model.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/data/models/bidding_type/bidding_type_item_model.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_type/bidding_type_item.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_type/bidding_type_response.dart';

class BiddingTypeResponseModel extends BiddingTypeResponse {
  BiddingTypeResponseModel(
      {super.id,
      super.name,
      super.subRelations,
      super.orderTypeId,
      super.service,
      super.inputsRequired});

  factory BiddingTypeResponseModel.fromMap(Map<String, dynamic> json) =>
      BiddingTypeResponseModel(
          id: json["id"],
          subRelations: json["subRelations"] != null
              ? List<BiddingTypeItem>.from(json["subRelations"]
                  .map((x) => BiddingTypeItemModel.fromMap(x)))
              : null,
          name: json["name"],
          orderTypeId: json["orderTypeId"],
          inputsRequired: json["inputsRequired"],
          service: json["service"] != null
              ? BiddingServiceItemModel.fromMap(json["service"])
              : null);
}
