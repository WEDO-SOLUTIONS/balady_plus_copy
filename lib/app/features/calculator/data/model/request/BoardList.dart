class BoardList {
  int? id;
  int? boardTypeId;
  double? width;
  double? length;

  BoardList({this.id, this.boardTypeId, this.width, this.length});

  factory BoardList.fromJson(Map<String, dynamic> json) =>
      _$BoardListFromJson(json);

  Map<String, dynamic> toJson() => _$BoardListToJson(this);
}

BoardList _$BoardListFromJson(Map<String, dynamic> json) {
  return BoardList(
      boardTypeId: json["BoardTypeId"],
      width: json["Width"],
      length: json["Length"]);
}

Map<String, dynamic> _$BoardListToJson(BoardList instance) => <String, dynamic>{
      "BoardTypeId": instance.boardTypeId,
      "Width": instance.width,
      "Length": instance.length
    };
