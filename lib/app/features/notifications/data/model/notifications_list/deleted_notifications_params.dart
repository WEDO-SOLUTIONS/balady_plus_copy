
class DeletedNotificationsParams {
  String channelId;
  bool all;
  List<String>? messages;

  DeletedNotificationsParams({
    required this.channelId,
    required this.all,
    this.messages,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "notificationId": "mobile-mobile",
      "all": all,
    };
    if(messages != null) {
      data["messages"] = messages;
    }
    return data;
  }
}

