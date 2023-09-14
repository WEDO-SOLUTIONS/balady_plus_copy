import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_type/bidding_type_item.dart';

class BiddingTypeItemModel extends BiddingTypeItem {
  BiddingTypeItemModel(
      {super.id,
      super.name,
      super.orderTypeId,
      super.inputsRequired,
      super.mandatory});

  factory BiddingTypeItemModel.fromMap(Map<String, dynamic> json) =>
      BiddingTypeItemModel(
          mandatory: json["mandatory"],
          id: json["id"],
          name: json["name"],
          orderTypeId: json["orderTypeId"],
          inputsRequired: json["inputsRequired"]);
}
