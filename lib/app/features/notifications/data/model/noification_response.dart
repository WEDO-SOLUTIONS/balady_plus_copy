class NotificationResponse {
  NotificationResponse({
    this.data,
  });

  NotificationResponse.fromJson(dynamic json) {
    data = json['result'];
  }
  bool? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['result'] = data;
    return map;
  }
}
