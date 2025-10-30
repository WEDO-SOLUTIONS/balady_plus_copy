class ProviderItem {
  String? id;
  String? mainImageUrl;
  String? serviceProviderName;
  String? description;
  double? ratingAverage;
  double? ratingsCount;
  String? logoImageUrl;
  double? totalEvaluationNumber;
  String? contact;

  ProviderItem(
      {this.id,
      this.logoImageUrl,
      this.mainImageUrl,
      this.ratingAverage,
      this.ratingsCount,
      this.description,
      this.serviceProviderName,
      this.totalEvaluationNumber,
      this.contact});
}
