class SessionData {
  SessionData({
      this.sessionId, 
      this.summary,});

  SessionData.fromJson(dynamic json) {
    sessionId = json['session_id'];
    summary = json['summary'];
  }
  String? sessionId;
  String? summary;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['session_id'] = sessionId;
    map['summary'] = summary;
    return map;
  }

}