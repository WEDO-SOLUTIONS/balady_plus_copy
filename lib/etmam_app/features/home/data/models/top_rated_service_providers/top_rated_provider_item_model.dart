/*
class TopRatedProviderItemModel extends TopRatedProviderItem {
  TopRatedProviderItemModel(
      {super.id,
      super.logoImageUrl,
      super.mainImageUrl,
      super.ratingAverage,
      super.serviceProviderName,
      super.totalEvaluationNumber});
 
  factory TopRatedProviderItemModel.fromMap(Map<String, dynamic> json) =>
      TopRatedProviderItemModel(
        id: json["id"],
        logoImageUrl: json["logoImageUrl"],
        mainImageUrl: json["mainImageUrl"],
        ratingAverage: json["ratingAverage"],
        serviceProviderName: json["serviceProviderName"],
        totalEvaluationNumber: json["totalEvaluationNumber"] != null
            ? json["totalEvaluationNumber"].toDouble()
            : null,
      );
}*/
