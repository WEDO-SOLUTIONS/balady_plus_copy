import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ProviderItem;

class ProviderItemModel extends ProviderItem {
  ProviderItemModel(
      {super.id,
      super.description,
      super.logoImageUrl,
      super.mainImageUrl,
      super.ratingAverage,
      super.ratingsCount,
      super.serviceProviderName,
      super.totalEvaluationNumber,
      super.contact});

  factory ProviderItemModel.fromMap(Map<String, dynamic> json) =>
      ProviderItemModel(
        id: json["id"],
        description: json["description"],
        logoImageUrl: json["logoImageUrl"],
        contact: json["contact"],
        mainImageUrl: json["mainImageUrl"],
        ratingAverage: json["ratingAverage"] != null
            ? json["ratingAverage"].toDouble()
            : null,
        ratingsCount: json["ratingsCount"] != null
            ? json["ratingsCount"].toDouble()
            : null,
        totalEvaluationNumber: json["totalEvaluationNumber"] != null
            ? json["totalEvaluationNumber"].toDouble()
            : null,
        serviceProviderName: json["serviceProviderName"],
      );
}
