
class MarkReadNotificationsParams {
  String channelId;
  bool all;
  bool read;
  List<String>? messages;

  MarkReadNotificationsParams({
    required this.channelId,
    required this.all,
    required this.read,
    this.messages,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "notificationId": "mobile-mobile",
      "all": all,
      "read": read,
    };
    if(messages != null) {
      data["messages"] = messages;
    }
    return data;
  }
}

