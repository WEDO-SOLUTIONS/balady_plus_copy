import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_type/bidding_service_item.dart';

class BiddingServiceItemModel extends BiddingServiceItem {
  BiddingServiceItemModel({super.id, super.logoUrl, super.name});

  factory BiddingServiceItemModel.fromMap(Map<String, dynamic> json) =>
      BiddingServiceItemModel(
          id: json["id"], name: json["name"], logoUrl: json["logoUrl"]);
}
