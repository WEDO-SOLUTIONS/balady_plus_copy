
class SearchNotificationsParams {
  String? query;
  //////////////////////////////////////
  String? serviceId;
  String? productId;

  //////////////////////////////////////
  //////////////////////////////////////
  //////////////////////////////////////
  int page;
  int pageSize;

  //////////////////////////////////////
  Map<String, dynamic> persoana;

  SearchNotificationsParams({
    this.serviceId,
    this.productId,
    this.page = 0,
    this.pageSize = 10,
    required this.persoana,
  });

  SearchNotificationsParams copyWith({
    String? serviceId,
    String? productId,
  }) =>
      SearchNotificationsParams(
        serviceId: serviceId,
        productId: productId ?? this.productId,
        persoana: persoana,
      );

  Map<String, dynamic> toJsonQueryParameters() {
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
    if (query != null && query!.isNotEmpty) {
      data["query"] = query;
    }
    return data;
  }
}
