class ChatRefreshSession {
  ChatRefreshSession({
      this.responseCode, 
      this.responseMessage, 
      this.responseId, 
      this.result,});

  ChatRefreshSession.fromJson(dynamic json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
  String? responseCode;
  String? responseMessage;
  String? responseId;
  Result? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['responseCode'] = responseCode;
    map['responseMessage'] = responseMessage;
    map['responseId'] = responseId;
    if (result != null) {
      map['result'] = result?.toJson();
    }
    return map;
  }

}

class Result {
  Result({
      this.sessionId,});

  Result.fromJson(dynamic json) {
    sessionId = json['sessionId'];
  }
  String? sessionId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sessionId'] = sessionId;
    return map;
  }

}