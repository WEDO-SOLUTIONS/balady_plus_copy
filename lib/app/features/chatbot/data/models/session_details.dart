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



}

class History {

  String? role;
  String? content;
  String? messageID;
  String? messageTime;
  bool? messageFeedBack;


  History({
      this.role, 
      this.content,
    this.messageID,
    this.messageTime,
    this.messageFeedBack,

  });


  History.fromJson(dynamic json) {
    role = json['role'];
    content = json['content'];
    messageID = json['message_id'];
    messageTime = json['message_time'];
    messageFeedBack = json['response_feedback'];
  }


}