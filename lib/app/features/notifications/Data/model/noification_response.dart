class NotificationResponse {
  NotificationResponse({
    this.data,});

  NotificationResponse.fromJson(dynamic json) {
    data = json['data'];
  }
  bool? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = data;
    return map;
  }

}