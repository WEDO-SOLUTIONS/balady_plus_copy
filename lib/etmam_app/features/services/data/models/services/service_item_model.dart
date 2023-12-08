import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show ServiceItems;

class ServiceItemModel extends ServiceItems {
  ServiceItemModel(
      {super.id,
      super.description,
      super.logoImageUrl,
      super.mainImageUrl,
      super.ratingAverage,
      super.ratingsCount,
      super.serviceProviderName,
      super.contact});

  factory ServiceItemModel.fromMap(Map<String, dynamic> json) =>
      ServiceItemModel(
        id: json["id"],
        description: json["description"],
        logoImageUrl: json["logoImageUrl"],
        mainImageUrl: json["mainImageUrl"],
        contact: json["contact"],
        ratingAverage: json["ratingAverage"] != null
            ? json["ratingAverage"].toDouble()
            : null,
        ratingsCount: json["ratingsCount"] != null
            ? json["ratingsCount"].toDouble()
            : null,
        serviceProviderName: json["serviceProviderName"],
      );
}
