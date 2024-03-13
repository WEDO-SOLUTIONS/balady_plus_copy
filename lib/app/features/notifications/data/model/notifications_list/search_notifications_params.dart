class SearchNotificationsParams {
  //////////////////////////////////////
  String? serviceId;
  String? productId;
  //////////////////////////////////////
  //////////////////////////////////////
  //////////////////////////////////////
  int page;
  int pageSize;
  //////////////////////////////////////

  SearchNotificationsParams({
    this.serviceId,
    this.productId,
    this.page = 0,
    this.pageSize = 10,
  });

  SearchNotificationsParams copyWith({
    String? serviceId,
    String? productId,
  }) =>
      SearchNotificationsParams(
        serviceId: serviceId,
        productId: productId ?? this.productId,
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "notification-channel-id": "mobile",
      "page": page,
      "page-size": pageSize,
    };
    if (serviceId != null) {
      data["service-id"] = serviceId;
    }
    if (productId != null) {
      data["product-id"] = productId;
    }
    return data;
  }
}
