class MarkReadNotificationsParams {
  String channelId;
  bool all;
  bool read;
  List<String>? messages;
  Map<String, dynamic>? persoana;
  String? serviceId;
  String? productId;

  MarkReadNotificationsParams({
    this.channelId = "mobile",
    required this.all,
    required this.read,
    this.persoana,
    this.serviceId,
    this.productId,
    this.messages,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "channelId": channelId,
      "all": all,
      "read": read,
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
