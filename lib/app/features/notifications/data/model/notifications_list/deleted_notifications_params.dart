class DeletedNotificationsParams {
  String channelId;
  bool all;
  List<String>? messages;
  Map<String, dynamic>? persoana;
  String? serviceId;
  String? productId;

  DeletedNotificationsParams({
    this.channelId = "mobile",
    required this.all,
    this.messages,
    this.serviceId,
    this.productId,
    this.persoana,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "channelId": channelId,
      "all": all,
    };
    if (messages != null) {
      data["messages"] = messages;
    }
    if (serviceId != null) {
      data["serviceId"] = serviceId;
    }
    if (productId != null) {
      data["productId"] = productId;
    }
    return data;
  }
}
