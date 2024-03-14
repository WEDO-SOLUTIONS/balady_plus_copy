class MarkReadNotificationsParams {
  String channelId;
  bool all;
  bool read;
  List<String>? messages;
  Map<String, dynamic>? persoana;

  MarkReadNotificationsParams({
    this.channelId = "mobile",
    required this.all,
    required this.read,
    this.persoana,
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
    return data;
  }
}
