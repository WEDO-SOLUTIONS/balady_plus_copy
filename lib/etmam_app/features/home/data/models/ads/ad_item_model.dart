import 'package:balady_plus/etmam_app/features/home/domain/entities/ads/ads_item.dart';

class AdItemModel extends AdsItem {
  AdItemModel({super.mainDescription, super.subDescription});

  factory AdItemModel.fromMap(Map<String, dynamic> json) => AdItemModel(
      mainDescription: json["mainDescription"],
      subDescription: json["subDescription"]);
}
