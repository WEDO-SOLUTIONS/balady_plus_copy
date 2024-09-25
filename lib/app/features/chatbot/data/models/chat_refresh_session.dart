class ChatRefreshSession {
  ChatRefreshSession({
      this.responseCode, 
      this.responseMessage, 
      this.responseId,});

  ChatRefreshSession.fromJson(dynamic json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
  }
  String? responseCode;
  String? responseMessage;
  String? responseId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['responseCode'] = responseCode;
    map['responseMessage'] = responseMessage;
    map['responseId'] = responseId;
    return map;
  }

}