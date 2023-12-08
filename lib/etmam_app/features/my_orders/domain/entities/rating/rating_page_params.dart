class RatingPageParams {
  String? orderId;
  String? providerName;
  String? logoUrl;
  Function? refresh;

  RatingPageParams(
      {this.orderId, this.providerName, this.logoUrl, this.refresh});
}
