class SessionDetails {
  SessionDetails({
      this.sessionId, 
      this.history,});

  SessionDetails.fromJson(dynamic json) {
    sessionId = json['session_id'];
    if (json['history'] != null) {
      history = [];
      json['history'].forEach((v) {
        history?.add(History.fromJson(v));
      });
    }
  }
  String? sessionId;
  List<History>? history;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['session_id'] = sessionId;
    if (history != null) {
      map['history'] = history?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class History {
  History({
      this.role, 
      this.content,});

  History.fromJson(dynamic json) {
    role = json['role'];
    content = json['content'];
  }
  String? role;
  String? content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['role'] = role;
    map['content'] = content;
    return map;
  }

}