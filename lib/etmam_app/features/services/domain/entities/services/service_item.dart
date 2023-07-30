class ServiceItems {
  String? id;
  String? description;
  String? mainImageUrl;
  double? ratingsCount;
  String? serviceProviderName;
  double? ratingAverage;
  String? logoImageUrl;
  String? contact;
  bool? isSelected;

  ServiceItems(
      {this.description,
      this.id,
      this.logoImageUrl,
      this.mainImageUrl,
      this.ratingAverage,
      this.ratingsCount,
      this.serviceProviderName,
      this.isSelected,
      this.contact});
}
