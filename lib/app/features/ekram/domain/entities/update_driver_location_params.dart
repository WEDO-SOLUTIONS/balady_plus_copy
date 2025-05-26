class UpdateDriverLocationParams {
  //int deadInfoRecordId;
  double x;
  double y;
  int requestId;

  UpdateDriverLocationParams(
      { //required this.deadInfoRecordId,

      required this.x,
      required this.y,
       required this.requestId
      });

  Map<String, dynamic> toMap() => {
        //"deadInfoRecordId": deadInfoRecordId,
        "x": x, "y": y
      };
}
