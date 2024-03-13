
class DeletedNotificationsParams {
  String channelId;
  bool all;
  List<String>? messages;

  DeletedNotificationsParams({
    this.channelId = "mobile",
    required this.all,
    this.messages,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "channelId": channelId,
      "all": all,
    };
    if(messages != null) {
      data["messages"] = messages;
    }
    return data;
  }
}

