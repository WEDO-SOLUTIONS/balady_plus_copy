class RequestNoteInfo {
  RequestNoteInfo({
      this.id, 
      this.note, 
      this.date, 
      this.employeeName, 
      this.reply,});

  RequestNoteInfo.fromJson(dynamic json) {
    id = json['id'];
    note = json['note'];
    date = json['date'];
    employeeName = json['employeeName'];
    reply = json['reply'];
  }
  int? id;
  String? note;
  String? date;
  String? employeeName;
  dynamic reply;
RequestNoteInfo copyWith({  int? id,
  String? note,
  String? date,
  String? employeeName,
  dynamic reply,
}) => RequestNoteInfo(  id: id ?? this.id,
  note: note ?? this.note,
  date: date ?? this.date,
  employeeName: employeeName ?? this.employeeName,
  reply: reply ?? this.reply,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['note'] = note;
    map['date'] = date;
    map['employeeName'] = employeeName;
    map['reply'] = reply;
    return map;
  }

}