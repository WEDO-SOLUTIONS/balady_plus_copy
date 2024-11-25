class CrAddNotesRequest {
  int? requestId;
  String? notes;

  CrAddNotesRequest({this.requestId, this.notes});

  Map<String, dynamic> toMap() {
    return {"notes": notes};
  }
}
